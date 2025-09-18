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
    // Add these properties
    @Published var hasLoadedUserProperties = false
    @Published var hasLoadedAllProperties = false
    
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
                completion(
                    .failure(
                        NSError(
                            domain: "CloudKitManager",
                            code: 1,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "Failed to fetch user record ID"
                            ]
                        )
                    )
                )
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
        // Skip if already loaded and no force refresh requested
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

    func placeBid(
        on property: PropertyListing,
        amount: Double,
        completion: @escaping (Result<Bid, Error>) -> Void
    ) {
        isLoading = true

        fetchUserID { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let userID):
                let bid = Bid(
                    id: UUID(),
                    recordID: nil,
                    propertyID: property.id,
                    bidderID: userID,
                    bidderName: "Current User",
                    amount: amount,
                    timestamp: Date(),
                    status: .pending
                )

                let record = bid.toCKRecord()

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
                                code: 3,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Failed to save bid"
                                ]
                            )
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }

                        var savedBid = bid
                        savedBid.recordID = savedRecord.recordID

                        self.updatePropertyHighestBid(
                            property: property,
                            newBid: amount
                        ) { _ in
                            
                        }

                        completion(.success(savedBid))
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

    private func updatePropertyHighestBid(
        property: PropertyListing,
        newBid: Double,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let recordID = property.recordID else {
            let error = NSError(
                domain: "CloudKitManager",
                code: 4,
                userInfo: [
                    NSLocalizedDescriptionKey: "Property record ID is missing"
                ]
            )
            completion(.failure(error))
            return
        }

        publicDB.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let record = record else {
                let error = NSError(
                    domain: "CloudKitManager",
                    code: 5,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Failed to fetch property record"
                    ]
                )
                completion(.failure(error))
                return
            }

            let currentHighestBid = record["highestBid"] as? Double ?? 0.0

            if newBid > currentHighestBid {
                record["highestBid"] = newBid

                self.publicDB.save(record) { _, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    completion(.success(()))
                }
            } else {
                completion(.success(()))
            }
        }
    }

    func fetchBidsForProperty(
        _ property: PropertyListing,
        completion: @escaping (Result<[Bid], Error>) -> Void
    ) {
        let predicate = NSPredicate(
            format: "propertyID == %@",
            property.id.uuidString
        )
        let query = CKQuery(recordType: "Bid", predicate: predicate)

        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = CKQueryOperation.maximumResults

        var fetchedRecords: [CKRecord] = []

        operation.recordMatchedBlock = { (_, result) in
            switch result {
            case .success(let record):
                fetchedRecords.append(record)
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        operation.queryResultBlock = { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let bids = fetchedRecords.compactMap {
                        Bid.fromCKRecord($0)
                    }
                    completion(.success(bids))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        publicDB.add(operation)
    }

}
