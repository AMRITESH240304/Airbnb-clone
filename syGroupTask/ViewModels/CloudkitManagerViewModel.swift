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
    
    // Payment related
    @Published var userPayments: [Payment] = []
    @Published var hasLoadedPayments = false
    @Published var allPayments: [Payment] = []
    @Published var revenueData: RevenueData = RevenueData()

    private let container: CKContainer
    private let publicDB: CKDatabase
    private let privateDB: CKDatabase

    @Published var userProperties: [PropertyListing] = []
    @Published var allProperties: [PropertyListing] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Make cachedUserID accessible
    var cachedUserID: String? {
        return _cachedUserID
    }
    private var _cachedUserID: String?

    @Published var professionals: [Professional] = []
    @Published var hasLoadedProfessionals = false
    @Published var currentUserProfessional: Professional?

    // Add these properties to the class
    @Published var collaborations: [Collaboration] = []
    @Published var hasLoadedCollaborations = false
    @Published var currentUserCollaboration: Collaboration?

    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
        cacheUserID()
        fetchUserPayments()
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
                    highestBid: nil,
                    listingTier: .basic,
                    isPremium: false,
                    isFeatured: false,
                    contactCount: 0
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

    // MARK: - Payment Methods
    
    func hasUserPaidForContact(property: PropertyListing) -> Bool {
        guard let cachedUserID = cachedUserID else { return false }
        
        return userPayments.contains { payment in
            payment.propertyID == property.id &&
            payment.payerID == cachedUserID &&
            payment.paymentType == .propertyContact &&
            payment.paymentStatus == .completed
        }
    }
    
    func canUserContactOwner(property: PropertyListing) -> Bool {
        let hasPaid = hasUserPaidForContact(property: property)
        let isOwner = isPropertyOwnedByCurrentUser(property)
        
        return hasPaid && !isOwner
    }
    
    func processContactOwnerPayment(
        property: PropertyListing,
        completion: @escaping (Result<Payment, Error>) -> Void
    ) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                // Check if user has already paid for this property contact
                if self.hasUserPaidForContact(property: property) {
                    let error = NSError(
                        domain: "PaymentManager",
                        code: 100,
                        userInfo: [NSLocalizedDescriptionKey: "Already paid for this contact"]
                    )
                    completion(.failure(error))
                    return
                }
                
                // Check if user is trying to pay for their own property
                if self.isPropertyOwnedByCurrentUser(property) {
                    let error = NSError(
                        domain: "PaymentManager",
                        code: 101,
                        userInfo: [NSLocalizedDescriptionKey: "Cannot pay to contact your own property"]
                    )
                    completion(.failure(error))
                    return
                }
                
                let amount = RevenueConfig.contactOwnerFee
                let platformFeeAmount = amount * (RevenueConfig.platformFeePercentage / 100)
                let netAmount = amount - platformFeeAmount
                
                let payment = Payment(
                    id: UUID(),
                    recordID: nil,
                    propertyID: property.id,
                    propertyTitle: property.title,
                    propertyLocation: property.location,
                    payerID: userID,
                    payerName: "Current User",
                    recipientID: property.ownerID,
                    recipientName: property.ownerName,
                    amount: amount,
                    paymentType: .propertyContact,
                    paymentMethod: .upi,
                    paymentStatus: .completed,
                    transactionDate: Date(),
                    description: "Contact fee for property: \(property.title)",
                    platformFeePercentage: RevenueConfig.platformFeePercentage,
                    platformFeeAmount: platformFeeAmount,
                    netAmount: netAmount
                )
                
                let record = payment.toCKRecord()
                
                // Changed from privateDB to publicDB for development
                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }
                        
                        guard let savedRecord = savedRecord else {
                            let error = NSError(
                                domain: "PaymentManager",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to save payment record"]
                            )
                            completion(.failure(error))
                            return
                        }
                        
                        var savedPayment = payment
                        savedPayment.recordID = savedRecord.recordID
                        self.userPayments.append(savedPayment)
                        
                        // Update property contact count
                        self.incrementPropertyContactCount(property: property)
                        
                        completion(.success(savedPayment))
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
    
    func cacheUserID() {
        fetchUserID { [weak self] result in
            if case .success(let userID) = result {
                self?._cachedUserID = userID
            }
        }
    }
    
    func isPropertyOwnedByCurrentUser(_ property: PropertyListing) -> Bool {
        return cachedUserID == property.ownerID
    }

    func fetchUserPayments(forceRefresh: Bool = false) {
        if hasLoadedPayments && !forceRefresh && !userPayments.isEmpty {
            return
        }
        
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                self.isLoading = true
                
                let predicate = NSPredicate(format: "payerID == %@", userID)
                let query = CKQuery(recordType: "Payment", predicate: predicate)
                query.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending: false)]
                
                let operation = CKQueryOperation(query: query)
                operation.resultsLimit = CKQueryOperation.maximumResults
                
                var fetchedRecords: [CKRecord] = []
                
                operation.recordMatchedBlock = { (_, result) in
                    switch result {
                    case .success(let record):
                        fetchedRecords.append(record)
                    case .failure(let error):
                        print("Error fetching payment record: \(error)")
                    }
                }
                
                operation.queryResultBlock = { [weak self] result in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        
                        self.isLoading = false
                        
                        switch result {
                        case .success:
                            let payments = fetchedRecords.compactMap { Payment.fromCKRecord($0) }
                            self.userPayments = payments
                            self.hasLoadedPayments = true
                            
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                            print("Failed to fetch user payments: \(error)")
                        }
                    }
                }
                
                // Changed from privateDB to publicDB for development
                self.publicDB.add(operation)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print("Failed to get user ID: \(error)")
                }
            }
        }
    }

    // MARK: - Existing Methods (unchanged)
    
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

    // MARK: - Wishlist Methods (unchanged)

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
    
    private func incrementPropertyContactCount(property: PropertyListing) {
        guard let recordID = property.recordID else { return }
        
        publicDB.fetch(withRecordID: recordID) { [weak self] record, error in
            guard let self = self, let record = record else { return }
            
            let currentCount = record["contactCount"] as? Int ?? 0
            record["contactCount"] = currentCount + 1
            
            self.publicDB.save(record) { _, _ in
                // Update local property as well
                DispatchQueue.main.async {
                    if let index = self.allProperties.firstIndex(where: { $0.id == property.id }) {
                        self.allProperties[index].contactCount += 1
                    }
                    if let index = self.userProperties.firstIndex(where: { $0.id == property.id }) {
                        self.userProperties[index].contactCount += 1
                    }
                }
            }
        }
    }
    
    // MARK: - Revenue Analytics Methods
    
    func fetchUserRevenue() {
        fetchAllPayments { [weak self] in
            self?.calculateRevenueData()
        }
    }
    
    func fetchAllPayments(completion: (() -> Void)? = nil) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Payment", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "transactionDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = CKQueryOperation.maximumResults
        
        var fetchedRecords: [CKRecord] = []
        
        operation.recordMatchedBlock = { (_, result) in
            switch result {
            case .success(let record):
                fetchedRecords.append(record)
            case .failure(let error):
                print("Error fetching payment record: \(error)")
            }
        }
        
        operation.queryResultBlock = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    let payments = fetchedRecords.compactMap { Payment.fromCKRecord($0) }
                    self.allPayments = payments
                    completion?()
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Failed to fetch all payments: \(error)")
                }
            }
        }
        
        publicDB.add(operation)
    }
    
    func getAllPayments() -> [Payment] {
        return allPayments
    }
    
    func getUserReceivedPayments() -> [Payment] {
        guard let userID = _cachedUserID else { return [] }
        return allPayments.filter { $0.recipientID == userID }
    }
    
    func getUserSentPayments() -> [Payment] {
        guard let userID = _cachedUserID else { return [] }
        return allPayments.filter { $0.payerID == userID }
    }
    
    private func calculateRevenueData() {
        guard let userID = _cachedUserID else { return }
        
        let receivedPayments = allPayments.filter { $0.recipientID == userID && $0.paymentStatus == .completed }
        
        // Calculate total amounts
        let totalAmount = receivedPayments.reduce(0) { $0 + $1.netAmount }
        let totalPlatformFee = receivedPayments.reduce(0) { $0 + $1.platformFeeAmount }
        let paymentCount = receivedPayments.count
        
        // Group by property
        let propertyGroups = Dictionary(grouping: receivedPayments) { $0.propertyID }
        let propertyRevenue = propertyGroups.map { (propertyID, payments) in
            let revenue = payments.reduce(0) { $0 + $1.netAmount }
            let contactCount = payments.count
            let firstPayment = payments.first!
            
            return PropertyRevenueData(
                propertyID: propertyID,
                propertyTitle: firstPayment.propertyTitle,
                propertyLocation: firstPayment.propertyLocation,
                revenue: revenue,
                contactCount: contactCount
            )
        }.sorted { $0.revenue > $1.revenue }
        
        // Group by payment type
        let typeGroups = Dictionary(grouping: receivedPayments) { $0.paymentType }
        let typeRevenue = typeGroups.map { (type, payments) in
            let revenue = payments.reduce(0) { $0 + $1.netAmount }
            return TypeRevenueData(type: type.rawValue, revenue: revenue)
        }
        
        // Monthly data
        let calendar = Calendar.current
        let monthlyGroups = Dictionary(grouping: receivedPayments) { payment in
            calendar.dateInterval(of: .month, for: payment.transactionDate)?.start ?? payment.transactionDate
        }
        
        let monthlyData = monthlyGroups.map { (month, payments) in
            let revenue = payments.reduce(0) { $0 + $1.netAmount }
            return MonthlyRevenueData(month: month, revenue: revenue)
        }.sorted { $0.month < $1.month }
        
        DispatchQueue.main.async {
            self.revenueData = RevenueData(
                totalAmount: totalAmount,
                totalPlatformFee: totalPlatformFee,
                paymentCount: paymentCount,
                propertyCount: propertyGroups.count,
                propertyRevenue: propertyRevenue,
                typeRevenue: typeRevenue,
                monthlyData: monthlyData
            )
        }
    }
    
    func getFilteredRevenue(for timeFrame: TimeFrame) -> RevenueData {
        guard let userID = _cachedUserID else { return RevenueData() }
        
        let calendar = Calendar.current
        let now = Date()
        
        let filteredPayments: [Payment]
        
        switch timeFrame {
        case .thisWeek:
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            filteredPayments = allPayments.filter { 
                $0.recipientID == userID && 
                $0.paymentStatus == .completed && 
                $0.transactionDate >= weekStart 
            }
        case .thisMonth:
            let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
            filteredPayments = allPayments.filter { 
                $0.recipientID == userID && 
                $0.paymentStatus == .completed && 
                $0.transactionDate >= monthStart 
            }
        case .last3Months:
            let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) ?? now
            filteredPayments = allPayments.filter { 
                $0.recipientID == userID && 
                $0.paymentStatus == .completed && 
                $0.transactionDate >= threeMonthsAgo 
            }
        case .thisYear:
            let yearStart = calendar.dateInterval(of: .year, for: now)?.start ?? now
            filteredPayments = allPayments.filter { 
                $0.recipientID == userID && 
                $0.paymentStatus == .completed && 
                $0.transactionDate >= yearStart 
            }
        case .allTime:
            filteredPayments = allPayments.filter { 
                $0.recipientID == userID && 
                $0.paymentStatus == .completed 
            }
        }
        
        // Calculate filtered revenue data similar to calculateRevenueData()
        let totalAmount = filteredPayments.reduce(0) { $0 + $1.netAmount }
        let totalPlatformFee = filteredPayments.reduce(0) { $0 + $1.platformFeeAmount }
        let paymentCount = filteredPayments.count
        
        let propertyGroups = Dictionary(grouping: filteredPayments) { $0.propertyID }
        let propertyRevenue = propertyGroups.map { (propertyID, payments) in
            let revenue = payments.reduce(0) { $0 + $1.netAmount }
            let contactCount = payments.count
            let firstPayment = payments.first!
            
            return PropertyRevenueData(
                propertyID: propertyID,
                propertyTitle: firstPayment.propertyTitle,
                propertyLocation: firstPayment.propertyLocation,
                revenue: revenue,
                contactCount: contactCount
            )
        }.sorted { $0.revenue > $1.revenue }
        
        let typeGroups = Dictionary(grouping: filteredPayments) { $0.paymentType }
        let typeRevenue = typeGroups.map { (type, payments) in
            let revenue = payments.reduce(0) { $0 + $1.netAmount }
            return TypeRevenueData(type: type.rawValue, revenue: revenue)
        }
        
        let monthlyGroups = Dictionary(grouping: filteredPayments) { payment in
            calendar.dateInterval(of: .month, for: payment.transactionDate)?.start ?? payment.transactionDate
        }
        
        let monthlyData = monthlyGroups.map { (month, payments) in
            let revenue = payments.reduce(0) { $0 + $1.netAmount }
            return MonthlyRevenueData(month: month, revenue: revenue)
        }.sorted { $0.month < $1.month }
        
        return RevenueData(
            totalAmount: totalAmount,
            totalPlatformFee: totalPlatformFee,
            paymentCount: paymentCount,
            propertyCount: propertyGroups.count,
            propertyRevenue: propertyRevenue,
            typeRevenue: typeRevenue,
            monthlyData: monthlyData
        )
    }
    
    // MARK: - Professional Methods
    
    func processProfessionalRegistrationPayment(completion: @escaping (Result<Payment, Error>) -> Void) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                let amount = RevenueConfig.professionalRegistrationFee
                let platformFeeAmount = amount * (RevenueConfig.platformFeePercentage / 100)
                let netAmount = amount - platformFeeAmount
                
                let payment = Payment(
                    id: UUID(),
                    recordID: nil,
                    propertyID: UUID(), // Placeholder - not property related
                    propertyTitle: "Professional Registration",
                    propertyLocation: "Platform Service",
                    payerID: userID,
                    payerName: "Current User",
                    recipientID: "platform",
                    recipientName: "Platform",
                    amount: amount,
                    paymentType: .professionalRegistration,
                    paymentMethod: .upi,
                    paymentStatus: .completed,
                    transactionDate: Date(),
                    description: "Professional registration fee",
                    platformFeePercentage: RevenueConfig.platformFeePercentage,
                    platformFeeAmount: platformFeeAmount,
                    netAmount: netAmount
                )
                
                let record = payment.toCKRecord()
                
                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let savedRecord = savedRecord else {
                            let error = NSError(domain: "PaymentManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save payment record"])
                            completion(.failure(error))
                            return
                        }
                        
                        var savedPayment = payment
                        savedPayment.recordID = savedRecord.recordID
                        self.userPayments.append(savedPayment)
                        
                        completion(.success(savedPayment))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createProfessionalProfile(from formData: ProfessionalRegistrationFormData, completion: @escaping (Result<Professional, Error>) -> Void) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                let experience = Int(formData.experience) ?? 0
                
                // Ensure we have at least one category
                let categories = Array(formData.selectedCategories)
                guard !categories.isEmpty else {
                    let error = NSError(domain: "ProfessionalCreation", code: 1, userInfo: [NSLocalizedDescriptionKey: "At least one category must be selected"])
                    completion(.failure(error))
                    return
                }
                
                let professional = Professional(
                    id: UUID(),
                    recordID: nil,
                    userID: userID,
                    userName: "Current User", // Get from user profile
                    businessName: formData.businessName,
                    description: formData.description,
                    phoneNumber: formData.phoneNumber,
                    email: formData.email,
                    location: formData.location,
                    website: formData.website.isEmpty ? nil : formData.website,
                    services: formData.services, // Can be empty
                    categories: categories,
                    experience: experience,
                    profileImageURL: formData.profileImageURL.isEmpty ? nil : formData.profileImageURL,
                    portfolioImages: formData.portfolioImages, // Can be empty
                    rating: 0.0,
                    reviewCount: 0,
                    isVerified: false,
                    isPremium: false,
                    registrationDate: Date(),
                    subscriptionEndDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
                    status: .active
                )
                
                let record = professional.toCKRecord()
                
                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let savedRecord = savedRecord else {
                            let error = NSError(domain: "CloudKitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save professional record"])
                            completion(.failure(error))
                            return
                        }
                        
                        var savedProfessional = professional
                        savedProfessional.recordID = savedRecord.recordID
                        self.professionals.append(savedProfessional)
                        self.currentUserProfessional = savedProfessional
                        
                        completion(.success(savedProfessional))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAllProfessionals(forceRefresh: Bool = false) {
        if hasLoadedProfessionals && !forceRefresh && !professionals.isEmpty {
            return
        }
        
        isLoading = true
        
        let predicate = NSPredicate(format: "status == %@", ProfessionalStatus.active.rawValue)
        let query = CKQuery(recordType: "Professional", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "registrationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = CKQueryOperation.maximumResults
        
        var fetchedRecords: [CKRecord] = []
        
        operation.recordMatchedBlock = { (_, result) in
            switch result {
            case .success(let record):
                fetchedRecords.append(record)
            case .failure(let error):
                print("Error fetching professional record: \(error)")
            }
        }
        
        operation.queryResultBlock = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success:
                    let professionals = fetchedRecords.compactMap { Professional.fromCKRecord($0) }
                    self.professionals = professionals
                    self.hasLoadedProfessionals = true
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Failed to fetch professionals: \(error)")
                }
            }
        }
        
        publicDB.add(operation)
    }
    
    func isUserProfessional() -> Bool {
        guard let userID = cachedUserID else { return false }
        return professionals.contains { $0.userID == userID && $0.status == .active }
    }
    
    func getCurrentUserProfessional() -> Professional? {
        guard let userID = cachedUserID else { return nil }
        return professionals.first { $0.userID == userID }
    }
    
    func hasUserPaidForProfessionalContact(professional: Professional) -> Bool {
        guard let cachedUserID = cachedUserID else { return false }
        
        return userPayments.contains { payment in
            payment.propertyID == professional.id &&
            payment.payerID == cachedUserID &&
            payment.paymentType == .professionalService &&
            payment.paymentStatus == .completed
        }
    }
    
    func processProfessionalContactPayment(
        professional: Professional,
        completion: @escaping (Result<Payment, Error>) -> Void
    ) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                // Check if user has already paid for this professional contact
                let hasAlreadyPaid = self.userPayments.contains { payment in
                    payment.propertyID == professional.id &&
                    payment.payerID == userID &&
                    payment.paymentType == .professionalService &&
                    payment.paymentStatus == .completed
                }
                
                if hasAlreadyPaid {
                    let error = NSError(
                        domain: "PaymentManager",
                        code: 100,
                        userInfo: [NSLocalizedDescriptionKey: "Already paid for this professional contact"]
                    )
                    completion(.failure(error))
                    return
                }
                
                // Check if user is trying to pay for their own professional profile
                if professional.userID == userID {
                    let error = NSError(
                        domain: "PaymentManager",
                        code: 101,
                        userInfo: [NSLocalizedDescriptionKey: "Cannot pay to contact your own professional profile"]
                    )
                    completion(.failure(error))
                    return
                }
                
                let amount = RevenueConfig.contactOwnerFee
                let platformFeeAmount = amount * (RevenueConfig.platformFeePercentage / 100)
                let netAmount = amount - platformFeeAmount
                
                let payment = Payment(
                    id: UUID(),
                    recordID: nil,
                    propertyID: professional.id,
                    propertyTitle: professional.businessName,
                    propertyLocation: professional.location,
                    payerID: userID,
                    payerName: "Current User",
                    recipientID: professional.userID,
                    recipientName: professional.userName,
                    amount: amount,
                    paymentType: .professionalService,
                    paymentMethod: .upi,
                    paymentStatus: .completed,
                    transactionDate: Date(),
                    description: "Contact fee for professional: \(professional.businessName)",
                    platformFeePercentage: RevenueConfig.platformFeePercentage,
                    platformFeeAmount: platformFeeAmount,
                    netAmount: netAmount
                )
                
                let record = payment.toCKRecord()
                
                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }
                        
                        guard let savedRecord = savedRecord else {
                            let error = NSError(
                                domain: "PaymentManager",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to save payment record"]
                            )
                            completion(.failure(error))
                            return
                        }
                        
                        var savedPayment = payment
                        savedPayment.recordID = savedRecord.recordID
                        self.userPayments.append(savedPayment)
                        
                        completion(.success(savedPayment))
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
    
    // Add these methods to the CloudkitManagerViewModel class

    // MARK: - Collaboration Methods

    func processCollaborationRegistrationPayment(completion: @escaping (Result<Payment, Error>) -> Void) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                let amount = RevenueConfig.collaborationRegistrationFee
                let platformFeeAmount = amount * (RevenueConfig.platformFeePercentage / 100)
                let netAmount = amount - platformFeeAmount
                
                let payment = Payment(
                    id: UUID(),
                    recordID: nil,
                    propertyID: UUID(), // Placeholder - not property related
                    propertyTitle: "Collaboration Registration",
                    propertyLocation: "Platform Service",
                    payerID: userID,
                    payerName: "Current User",
                    recipientID: "platform",
                    recipientName: "Platform",
                    amount: amount,
                    paymentType: .collaborationRegistration,
                    paymentMethod: .upi,
                    paymentStatus: .completed,
                    transactionDate: Date(),
                    description: "Collaboration registration fee",
                    platformFeePercentage: RevenueConfig.platformFeePercentage,
                    platformFeeAmount: platformFeeAmount,
                    netAmount: netAmount
                )
                
                let record = payment.toCKRecord()
                
                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let savedRecord = savedRecord else {
                            let error = NSError(domain: "PaymentManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save payment record"])
                            completion(.failure(error))
                            return
                        }
                        
                        var savedPayment = payment
                        savedPayment.recordID = savedRecord.recordID
                        self.userPayments.append(savedPayment)
                        
                        completion(.success(savedPayment))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createCollaborationProfile(from formData: CollaborationRegistrationFormData, completion: @escaping (Result<Collaboration, Error>) -> Void) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                let collaboration = Collaboration(
                    id: UUID(),
                    recordID: nil,
                    userID: userID,
                    userName: "Current User",
                    businessName: formData.businessName,
                    businessType: formData.businessType,
                    collaborationType: formData.collaborationType,
                    description: formData.description,
                    location: formData.location,
                    contactEmail: formData.contactEmail,
                    contactPhone: formData.contactPhone,
                    website: formData.website.isEmpty ? nil : formData.website,
                    logoImageURL: formData.logoImageURL.isEmpty ? nil : formData.logoImageURL,
                    businessImages: [], // Start with empty array - can be updated later
                    investmentRange: formData.investmentRange,
                    expectedROI: formData.expectedROI,
                    businessModel: formData.businessModel,
                    experienceRequired: formData.experienceRequired,
                    supportProvided: Array(formData.supportProvided), // Convert Set to Array
                    isVerified: false,
                    isPremium: false,
                    rating: 0.0,
                    reviewCount: 0,
                    registrationDate: Date(),
                    status: .active
                )
                
                let record = collaboration.toCKRecord()
                
                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let savedRecord = savedRecord else {
                            let error = NSError(domain: "CloudKitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to save collaboration record"])
                            completion(.failure(error))
                            return
                        }
                        
                        var savedCollaboration = collaboration
                        savedCollaboration.recordID = savedRecord.recordID
                        self.collaborations.append(savedCollaboration)
                        self.currentUserCollaboration = savedCollaboration
                        
                        completion(.success(savedCollaboration))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchAllCollaborations(forceRefresh: Bool = false) {
        if hasLoadedCollaborations && !forceRefresh && !collaborations.isEmpty {
            return
        }
        
        isLoading = true
        
        let predicate = NSPredicate(format: "status == %@", CollaborationStatus.active.rawValue)
        let query = CKQuery(recordType: "Collaboration", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "registrationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = CKQueryOperation.maximumResults
        
        var fetchedRecords: [CKRecord] = []
        
        operation.recordMatchedBlock = { (_, result) in
            switch result {
            case .success(let record):
                fetchedRecords.append(record)
            case .failure(let error):
                print("Error fetching collaboration record: \(error)")
            }
        }
        
        operation.queryResultBlock = { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success:
                    let collaborations = fetchedRecords.compactMap { Collaboration.fromCKRecord($0) }
                    self.collaborations = collaborations
                    self.hasLoadedCollaborations = true
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Failed to fetch collaborations: \(error)")
                }
            }
        }
        
        publicDB.add(operation)
    }
    
    func isUserCollaborator() -> Bool {
        guard let userID = cachedUserID else { return false }
        return collaborations.contains { $0.userID == userID && $0.status == .active }
    }
    
    func getCurrentUserCollaboration() -> Collaboration? {
        guard let userID = cachedUserID else { return nil }
        return collaborations.first { $0.userID == userID }
    }
    
    func hasUserPaidForCollaborationContact(collaboration: Collaboration) -> Bool {
        guard let cachedUserID = cachedUserID else { return false }
        
        return userPayments.contains { payment in
            payment.propertyID == collaboration.id &&
            payment.payerID == cachedUserID &&
            payment.paymentType == .collaborationContact &&
            payment.paymentStatus == .completed
        }
    }
    
    func processCollaborationContactPayment(
        collaboration: Collaboration,
        completion: @escaping (Result<Payment, Error>) -> Void
    ) {
        fetchUserID { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userID):
                // Check if user has already paid for this collaboration contact
                let hasAlreadyPaid = self.userPayments.contains { payment in
                    payment.propertyID == collaboration.id &&
                    payment.payerID == userID &&
                    payment.paymentType == .collaborationContact &&
                    payment.paymentStatus == .completed
                }
                
                if hasAlreadyPaid {
                    let error = NSError(
                        domain: "PaymentManager",
                        code: 100,
                        userInfo: [NSLocalizedDescriptionKey: "Already paid for this collaboration contact"]
                    )
                    completion(.failure(error))
                    return
                }
                
                // Check if user is trying to pay for their own collaboration
                if collaboration.userID == userID {
                    let error = NSError(
                        domain: "PaymentManager",
                        code: 101,
                        userInfo: [NSLocalizedDescriptionKey: "Cannot pay to contact your own collaboration"]
                    )
                    completion(.failure(error))
                    return
                }
                
                let amount = RevenueConfig.contactOwnerFee
                let platformFeeAmount = amount * (RevenueConfig.platformFeePercentage / 100)
                let netAmount = amount - platformFeeAmount
                
                let payment = Payment(
                    id: UUID(),
                    recordID: nil,
                    propertyID: collaboration.id,
                    propertyTitle: collaboration.businessName,
                    propertyLocation: collaboration.location,
                    payerID: userID,
                    payerName: "Current User",
                    recipientID: collaboration.userID,
                    recipientName: collaboration.userName,
                    amount: amount,
                    paymentType: .collaborationContact,
                    paymentMethod: .upi,
                    paymentStatus: .completed,
                    transactionDate: Date(),
                    description: "Contact fee for collaboration: \(collaboration.businessName)",
                    platformFeePercentage: RevenueConfig.platformFeePercentage,
                    platformFeeAmount: platformFeeAmount,
                    netAmount: netAmount
                )
                
                let record = payment.toCKRecord()
                
                self.publicDB.save(record) { (savedRecord, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            completion(.failure(error))
                            return
                        }
                        
                        guard let savedRecord = savedRecord else {
                            let error = NSError(
                                domain: "PaymentManager",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to save payment record"]
                            )
                            completion(.failure(error))
                            return
                        }
                        
                        var savedPayment = payment
                        savedPayment.recordID = savedRecord.recordID
                        self.userPayments.append(savedPayment)
                        
                        completion(.success(savedPayment))
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
}
