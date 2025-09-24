//
//  PaymentModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 20/09/25.
//

import Foundation
import CloudKit

struct Payment: Identifiable,Equatable {
    var id: UUID
    var recordID: CKRecord.ID?
    
    var propertyID: UUID
    var propertyTitle: String
    var propertyLocation: String
    var payerID: String
    var payerName: String
    var recipientID: String
    var recipientName: String
    
    var amount: Double
    var paymentType: PaymentType
    var paymentMethod: PaymentMethod
    var paymentStatus: PaymentStatus
    
    var transactionDate: Date
    var description: String
    
    var platformFeePercentage: Double
    var platformFeeAmount: Double
    
    var netAmount: Double
    
    // Add booking dates
    var bookingStartDate: Date?
    var bookingEndDate: Date?
    
    func toCKRecord() -> CKRecord {
        let record: CKRecord
        
        if let recordID = self.recordID {
            record = CKRecord(recordType: "Payment", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Payment")
        }
        
        record["id"] = id.uuidString
        record["propertyID"] = propertyID.uuidString
        record["propertyTitle"] = propertyTitle
        record["propertyLocation"] = propertyLocation
        record["payerID"] = payerID
        record["payerName"] = payerName
        record["recipientID"] = recipientID
        record["recipientName"] = recipientName
        record["amount"] = amount
        record["paymentType"] = paymentType.rawValue
        record["paymentMethod"] = paymentMethod.rawValue
        record["paymentStatus"] = paymentStatus.rawValue
        record["transactionDate"] = transactionDate
        record["description"] = description
        record["platformFeePercentage"] = platformFeePercentage
        record["platformFeeAmount"] = platformFeeAmount
        record["netAmount"] = netAmount
        
        if let bookingStartDate = bookingStartDate {
            record["bookingStartDate"] = bookingStartDate
        }
        if let bookingEndDate = bookingEndDate {
            record["bookingEndDate"] = bookingEndDate
        }
        
        return record
    }
    
    static func fromCKRecord(_ record: CKRecord) -> Payment? {
        guard
            let idString = record["id"] as? String,
            let id = UUID(uuidString: idString),
            let propertyIDString = record["propertyID"] as? String,
            let propertyID = UUID(uuidString: propertyIDString),
            let propertyTitle = record["propertyTitle"] as? String,
            let propertyLocation = record["propertyLocation"] as? String,
            let payerID = record["payerID"] as? String,
            let payerName = record["payerName"] as? String,
            let recipientID = record["recipientID"] as? String,
            let recipientName = record["recipientName"] as? String,
            let amount = record["amount"] as? Double,
            let paymentTypeRaw = record["paymentType"] as? String,
            let paymentType = PaymentType(rawValue: paymentTypeRaw),
            let paymentMethodRaw = record["paymentMethod"] as? String,
            let paymentMethod = PaymentMethod(rawValue: paymentMethodRaw),
            let paymentStatusRaw = record["paymentStatus"] as? String,
            let paymentStatus = PaymentStatus(rawValue: paymentStatusRaw),
            let transactionDate = record["transactionDate"] as? Date,
            let description = record["description"] as? String,
            let platformFeePercentage = record["platformFeePercentage"] as? Double,
            let platformFeeAmount = record["platformFeeAmount"] as? Double,
            let netAmount = record["netAmount"] as? Double
        else {
            return nil
        }
        
        let bookingStartDate = record["bookingStartDate"] as? Date
        let bookingEndDate = record["bookingEndDate"] as? Date
        
        return Payment(
            id: id,
            recordID: record.recordID,
            propertyID: propertyID,
            propertyTitle: propertyTitle,
            propertyLocation: propertyLocation,
            payerID: payerID,
            payerName: payerName,
            recipientID: recipientID,
            recipientName: recipientName,
            amount: amount,
            paymentType: paymentType,
            paymentMethod: paymentMethod,
            paymentStatus: paymentStatus,
            transactionDate: transactionDate,
            description: description,
            platformFeePercentage: platformFeePercentage,
            platformFeeAmount: platformFeeAmount,
            netAmount: netAmount,
            bookingStartDate: bookingStartDate,
            bookingEndDate: bookingEndDate
        )
    }
}

enum PaymentType: String, CaseIterable, Identifiable {
    case propertyContact = "Property Contact"
    case premiumListing = "Premium Listing"
    case featuredListing = "Featured Listing"
    case subscription = "Subscription"
    case commission = "Commission"
    case professionalRegistration = "Professional Registration"
    case professionalService = "Professional Service"
    case professionalSubscription = "Professional Subscription"
    case collaborationRegistration = "Collaboration Registration"
    case collaborationContact = "Collaboration Contact"
    
    var id: String { self.rawValue }
}

enum PaymentMethod: String, CaseIterable, Identifiable {
    case creditCard = "Credit Card"
    case debitCard = "Debit Card"
    case upi = "UPI"
    case netBanking = "Net Banking"
    case wallet = "Wallet"
    case razorpay = "Razorpay"
    
    var id: String { self.rawValue }
}

enum PaymentStatus: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case processing = "Processing"
    case completed = "Completed"
    case failed = "Failed"
    case refunded = "Refunded"
    case cancelled = "Cancelled"
    
    var id: String { self.rawValue }
}

struct RevenueConfig {
    static let contactOwnerFee: Double = 50.0
    static let premiumListingFee: Double = 500.0
    static let featuredListingFee: Double = 1000.0
    static let platformFeePercentage: Double = 5.0
    static let subscriptionMonthlyFee: Double = 299.0
    static let subscriptionYearlyFee: Double = 2999.0
    
    // Professional fees
    static let professionalRegistrationFee: Double = 1500.0
    static let professionalMonthlySubscription: Double = 499.0
    static let professionalYearlySubscription: Double = 4999.0
    static let professionalServiceCommission: Double = 10.0 // percentage
    
    // Collaboration fees
    static let collaborationRegistrationFee: Double = 2000.0
    static let collaborationMonthlySubscription: Double = 699.0
    static let collaborationYearlySubscription: Double = 6999.0
}
