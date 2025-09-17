//
//  PropertyModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 17/09/25.
//

import Foundation
import CloudKit

struct PropertyListing: Identifiable {
    // CKRecord ID for CloudKit
    var id: UUID
    var recordID: CKRecord.ID?
    
    // Basic property information
    var title: String
    var category: String
    var location: String
    var description: String
    
    // Listing type and pricing
    var listingType: ListingType
    var price: Double // selling price or monthly rent
    
    // Listing duration and status
    var listingDuration: Int // in days
    var listingDate: Date
    var expirationDate: Date
    var status: ListingStatus
    
    // User information
    var ownerID: String
    var ownerName: String
    
    // Images
    var photoURLs: [String]
    
    // Bids (if for sale)
    var bids: [Bid]?
    var highestBid: Double?
    
    // CloudKit record conversion
    func toCKRecord() -> CKRecord {
        let record: CKRecord
        
        if let recordID = self.recordID {
            record = CKRecord(recordType: "PropertyListing", recordID: recordID)
        } else {
            record = CKRecord(recordType: "PropertyListing")
        }
        
        record["id"] = id.uuidString
        record["title"] = title
        record["category"] = category
        record["location"] = location
        record["description"] = description
        record["listingType"] = listingType.rawValue
        record["price"] = price
        record["listingDuration"] = listingDuration
        record["listingDate"] = listingDate
        record["expirationDate"] = expirationDate
        record["status"] = status.rawValue
        record["ownerID"] = ownerID
        record["ownerName"] = ownerName
        record["photoURLs"] = photoURLs
        
        if let highestBid = highestBid {
            record["highestBid"] = highestBid
        }
        
        // Bids will be stored in separate records with references
        
        return record
    }
    
    // Create from CloudKit record
    static func fromCKRecord(_ record: CKRecord) -> PropertyListing? {
        guard
            let idString = record["id"] as? String,
            let id = UUID(uuidString: idString),
            let title = record["title"] as? String,
            let category = record["category"] as? String,
            let location = record["location"] as? String,
            let description = record["description"] as? String,
            let listingTypeRaw = record["listingType"] as? String,
            let listingType = ListingType(rawValue: listingTypeRaw),
            let price = record["price"] as? Double,
            let listingDuration = record["listingDuration"] as? Int,
            let listingDate = record["listingDate"] as? Date,
            let expirationDate = record["expirationDate"] as? Date,
            let statusRaw = record["status"] as? String,
            let status = ListingStatus(rawValue: statusRaw),
            let ownerID = record["ownerID"] as? String,
            let ownerName = record["ownerName"] as? String,
            let photoURLs = record["photoURLs"] as? [String]
        else {
            return nil
        }
        
        let highestBid = record["highestBid"] as? Double
        
        return PropertyListing(
            id: id,
            recordID: record.recordID,
            title: title,
            category: category,
            location: location,
            description: description,
            listingType: listingType,
            price: price,
            listingDuration: listingDuration,
            listingDate: listingDate,
            expirationDate: expirationDate,
            status: status,
            ownerID: ownerID,
            ownerName: ownerName,
            photoURLs: photoURLs,
            bids: [],
            highestBid: highestBid
        )
    }
}

// Listing type enum
enum ListingType: String, CaseIterable, Identifiable {
    case forSale = "For Sale"
    case forRent = "For Rent"
    
    var id: String { self.rawValue }
}

// Listing status enum
enum ListingStatus: String, CaseIterable, Identifiable {
    case active = "Active"
    case pending = "Pending"
    case sold = "Sold"
    case expired = "Expired"
    
    var id: String { self.rawValue }
}

// Bid model
struct Bid: Identifiable {
    var id: UUID
    var recordID: CKRecord.ID?
    
    var propertyID: UUID
    var bidderID: String
    var bidderName: String
    var amount: Double
    var timestamp: Date
    var status: BidStatus
    
    // CloudKit record conversion
    func toCKRecord() -> CKRecord {
        let record: CKRecord
        
        if let recordID = self.recordID {
            record = CKRecord(recordType: "Bid", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Bid")
        }
        
        record["id"] = id.uuidString
        record["propertyID"] = propertyID.uuidString
        record["bidderID"] = bidderID
        record["bidderName"] = bidderName
        record["amount"] = amount
        record["timestamp"] = timestamp
        record["status"] = status.rawValue
        
        return record
    }
    
    // Create from CloudKit record
    static func fromCKRecord(_ record: CKRecord) -> Bid? {
        guard
            let idString = record["id"] as? String,
            let id = UUID(uuidString: idString),
            let propertyIDString = record["propertyID"] as? String,
            let propertyID = UUID(uuidString: propertyIDString),
            let bidderID = record["bidderID"] as? String,
            let bidderName = record["bidderName"] as? String,
            let amount = record["amount"] as? Double,
            let timestamp = record["timestamp"] as? Date,
            let statusRaw = record["status"] as? String,
            let status = BidStatus(rawValue: statusRaw)
        else {
            return nil
        }
        
        return Bid(
            id: id,
            recordID: record.recordID,
            propertyID: propertyID,
            bidderID: bidderID,
            bidderName: bidderName,
            amount: amount,
            timestamp: timestamp,
            status: status
        )
    }
}

// Bid status enum
enum BidStatus: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case accepted = "Accepted"
    case rejected = "Rejected"
    case outbid = "Outbid"
    
    var id: String { self.rawValue }
}
