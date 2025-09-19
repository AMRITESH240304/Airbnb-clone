//
//  CloudkitManagerViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 17/09/25.
//

import CloudKit
import Combine
import Foundation

class CloudkitManagerViewModel: ObservableObject {
    @Published var hasLoadedUserProperties = false
    @Published var hasLoadedAllProperties = false
    @Published var wishlistItems: [Wishlist] = []
    @Published var wishlistedProperties: [PropertyListing] = []
    @Published var hasLoadedWishlist = false

    private let container: CKContainer
    private let publicDB: CKDatabase
    private let privateDB: CKDatabase

    @Published var userProperties: [PropertyListing] = []
    @Published var allProperties: [PropertyListing] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }

    func fetchUserID(completion: @escaping (Result<String, Error>) -> Void) {
        container.fetchUserRecordID { recordID, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let recordID = recordID else {
                let error = NSError(
                    domain: "CloudKitManager",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "Unable to fetch user record ID"]
                )
                completion(.failure(error))
                return
            }

            completion(.success(recordID.recordName))
        }
    }

    func createPropertyListing(
        from formData: PropertyFormData,
        completion: @escaping (Result<PropertyListing, Error>) -> Void
    ) {
        self.isLoading = true

        fetchUserID { result in
            switch result {
            case .success(let userID):
                let listingDate = Date()
                let expirationDate =
                    Calendar.current.date(
                        byAdding: .day,
                        value: formData.listingDuration,
                        to: listingDate
                    ) ?? Date()

                let price =
                    formData.listingType == .forSale
                    ? (Double(formData.price) ?? 0.0)
                    : (Double(formData.monthlyRent) ?? 0.0)

                var propertyListing = PropertyListing(
                    id: UUID(),
                    recordID: nil,
                    title: formData.title,
                    category: formData.category,
                    location: formData.location,
                    description: formData.description,
                    listingType: formData.listingType,
                    price: price,
                    listingDuration: formData.listingDuration,
                    listingDate: listingDate,
                    expirationDate: expirationDate,
                    status: .active,
                    ownerID: userID,
                    ownerName: "Current User",
                    photoURLs: formData.photoURLs.filter { !$0.isEmpty },
                    bids: [],
                    highestBid: nil
                )

                let record = propertyListing.toCKRecord()

                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        self.isLoading = false

                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }

                        guard let savedRecord = savedRecord else {
                            let error = NSError(
                                domain: "CloudKitManager",
                                code: 2,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Failed to save record"
                                ]
                            )
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }

                        propertyListing.recordID = savedRecord.recordID
                        self.userProperties.append(propertyListing)
                        completion(.success(propertyListing))
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchAllListings(forceRefresh: Bool = false) {
        if hasLoadedAllProperties && !forceRefresh && !allProperties.isEmpty {
            return
        }

        isLoading = true
        errorMessage = nil

        let predicate = NSPredicate(value: true)
        let query = CKQuery(
            recordType: "PropertyListing",
            predicate: predicate
        )

        query.sortDescriptors = [
            NSSortDescriptor(key: "listingDate", ascending: false)
        ]

        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = CKQueryOperation.maximumResults

        var fetchedRecords: [CKRecord] = []

        operation.recordMatchedBlock = { (_, result) in
            switch result {
            case .success(let record):
                fetchedRecords.append(record)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }

        operation.queryResultBlock = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case .success:
                    self.allProperties = fetchedRecords.compactMap {
                        PropertyListing.fromCKRecord($0)
                    }
                    self.hasLoadedAllProperties = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }

        publicDB.add(operation)
    }

    func fetchUserListings(forceRefresh: Bool = false) {
        if hasLoadedUserProperties && !forceRefresh && !userProperties.isEmpty {
            return
        }

        isLoading = true
        errorMessage = nil

        fetchUserID { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userID):
                let predicate = NSPredicate(format: "ownerID == %@", userID)
                let query = CKQuery(
                    recordType: "PropertyListing",
                    predicate: predicate
                )

                let operation = CKQueryOperation(query: query)
                operation.resultsLimit = CKQueryOperation.maximumResults

                var fetchedRecords: [CKRecord] = []

                operation.recordMatchedBlock = { (_, result) in
                    switch result {
                    case .success(let record):
                        fetchedRecords.append(record)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }

                operation.queryResultBlock = { [weak self] result in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.isLoading = false

                        switch result {
                        case .success:
                            self.userProperties = fetchedRecords.compactMap {
                                PropertyListing.fromCKRecord($0)
                            }
                            self.hasLoadedUserProperties = true
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }

                self.publicDB.add(operation)

            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // MARK: - Wishlist Methods

    func addToWishlist(
        property: PropertyListing,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userID):
                // Check if already in wishlist
                if self.wishlistItems.contains(where: { $0.propertyID == property.id && $0.ownerID == userID }) {
                    completion(.success(()))
                    return
                }

                let wishlistItem = Wishlist(
                    id: UUID(),
                    recordID: nil,
                    propertyID: property.id,
                    ownerID: userID,
                    dateAdded: Date()
                )

                let record = wishlistItem.toCKRecord()

                self.privateDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }

                        guard let savedRecord = savedRecord else {
                            let error = NSError(
                                domain: "CloudKitManager",
                                code: 6,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to save wishlist item"]
                            )
                            completion(.failure(error))
                            return
                        }

                        var savedWishlistItem = wishlistItem
                        savedWishlistItem.recordID = savedRecord.recordID
                        self.wishlistItems.append(savedWishlistItem)

                        // Add to wishlisted properties if not already there
                        if !self.wishlistedProperties.contains(where: { $0.id == property.id }) {
                            self.wishlistedProperties.append(property)
                        }

                        completion(.success(()))
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    func removeFromWishlist(property: PropertyListing, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userID):
                guard let wishlistItem = self.wishlistItems.first(where: {
                    $0.propertyID == property.id && $0.ownerID == userID
                }),
                let recordID = wishlistItem.recordID else {
                    completion(.success(()))
                    return
                }

                self.privateDB.delete(withRecordID: recordID) { (deletedRecordID, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }

                        // Remove from local arrays
                        self.wishlistItems.removeAll { $0.id == wishlistItem.id }
                        self.wishlistedProperties.removeAll { $0.id == property.id }

                        completion(.success(()))
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchUserWishlist(forceRefresh: Bool = false) {
        if hasLoadedWishlist && !forceRefresh && !wishlistItems.isEmpty {
            return
        }

        isLoading = true
        errorMessage = nil

        fetchUserID { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userID):
                let predicate = NSPredicate(format: "ownerID == %@", userID)
                let query = CKQuery(recordType: "Wishlist", predicate: predicate)
                query.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]

                let operation = CKQueryOperation(query: query)
                operation.resultsLimit = CKQueryOperation.maximumResults

                var fetchedRecords: [CKRecord] = []

                operation.recordMatchedBlock = { (_, result) in
                    switch result {
                    case .success(let record):
                        fetchedRecords.append(record)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }

                operation.queryResultBlock = { [weak self] result in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.isLoading = false

                        switch result {
                        case .success:
                            self.wishlistItems = fetchedRecords.compactMap {
                                Wishlist.fromCKRecord($0)
                            }
                            self.hasLoadedWishlist = true

                            // Fetch the actual properties for the wishlist
                            self.fetchWishlistedProperties()

                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }

                self.privateDB.add(operation)

            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func isPropertyInWishlist(_ property: PropertyListing) -> Bool {
        return wishlistItems.contains { $0.propertyID == property.id }
    }

    private func fetchWishlistedProperties() {
        let propertyIDs = wishlistItems.map { $0.propertyID.uuidString }

        guard !propertyIDs.isEmpty else {
            wishlistedProperties = []
            return
        }

        let predicate = NSPredicate(format: "id IN %@", propertyIDs)
        let query = CKQuery(recordType: "PropertyListing", predicate: predicate)

        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = CKQueryOperation.maximumResults

        var fetchedRecords: [CKRecord] = []

        operation.recordMatchedBlock = { (_, result) in
            switch result {
            case .success(let record):
                fetchedRecords.append(record)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }

        operation.queryResultBlock = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success:
                    self.wishlistedProperties = fetchedRecords.compactMap {
                        PropertyListing.fromCKRecord($0)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }

        publicDB.add(operation)
    }
}
