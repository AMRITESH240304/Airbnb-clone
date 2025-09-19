//
//  WishListModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 19/09/25.
//

import Foundation
import CloudKit

struct Wishlist: Identifiable,Equatable {
    var id: UUID
    var recordID: CKRecord.ID?
    
    var propertyID: UUID
    var ownerID: String
    var dateAdded: Date
    
    func toCKRecord() -> CKRecord {
        let record: CKRecord
        
        if let recordID = self.recordID {
            record = CKRecord(recordType: "Wishlist", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Wishlist")
        }
        
        record["id"] = id.uuidString
        record["propertyID"] = propertyID.uuidString
        record["ownerID"] = ownerID
        record["dateAdded"] = dateAdded
        
        return record
    }
    
    static func fromCKRecord(_ record: CKRecord) -> Wishlist? {
        guard
            let idString = record["id"] as? String,
            let id = UUID(uuidString: idString),
            let propertyIDString = record["propertyID"] as? String,
            let propertyID = UUID(uuidString: propertyIDString),
            let ownerID = record["ownerID"] as? String,
            let dateAdded = record["dateAdded"] as? Date
        else {
            return nil
        }
        
        return Wishlist(
            id: id,
            recordID: record.recordID,
            propertyID: propertyID,
            ownerID: ownerID,
            dateAdded: dateAdded
        )
    }
}
