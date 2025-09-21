//
//  CollaborationModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 21/09/25.
//

import Foundation
import CloudKit

struct Collaboration: Identifiable, Equatable {
    var id: UUID
    var recordID: CKRecord.ID?
    
    var userID: String
    var userName: String
    var businessName: String
    var businessType: BusinessType
    var collaborationType: CollaborationType
    var description: String
    var location: String
    var contactEmail: String
    var contactPhone: String
    var website: String?
    var logoImageURL: String?
    var businessImages: [String]
    
    var investmentRange: InvestmentRange
    var expectedROI: String
    var businessModel: String
    var experienceRequired: String
    var supportProvided: [String]
    
    var isVerified: Bool
    var isPremium: Bool
    var rating: Double
    var reviewCount: Int
    var registrationDate: Date
    var status: CollaborationStatus
    
    func toCKRecord() -> CKRecord {
        let record: CKRecord
        
        if let recordID = self.recordID {
            record = CKRecord(recordType: "Collaboration", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Collaboration")
        }
        
        record["id"] = id.uuidString
        record["userID"] = userID
        record["userName"] = userName
        record["businessName"] = businessName
        record["businessType"] = businessType.rawValue
        record["collaborationType"] = collaborationType.rawValue
        record["description"] = description
        record["location"] = location
        record["contactEmail"] = contactEmail
        record["contactPhone"] = contactPhone
        record["website"] = website
        record["logoImageURL"] = logoImageURL
        
        // Fix: Only save businessImages if it's not empty
        if !businessImages.isEmpty {
            record["businessImages"] = businessImages
        }
        
        record["investmentRange"] = investmentRange.rawValue
        record["expectedROI"] = expectedROI
        record["businessModel"] = businessModel
        record["experienceRequired"] = experienceRequired
        
        // Fix: Only save supportProvided if it's not empty
        if !supportProvided.isEmpty {
            record["supportProvided"] = supportProvided
        }
        
        record["isVerified"] = isVerified
        record["isPremium"] = isPremium
        record["rating"] = rating
        record["reviewCount"] = reviewCount
        record["registrationDate"] = registrationDate
        record["status"] = status.rawValue
        
        return record
    }
    
    static func fromCKRecord(_ record: CKRecord) -> Collaboration? {
        guard
            let idString = record["id"] as? String,
            let id = UUID(uuidString: idString),
            let userID = record["userID"] as? String,
            let userName = record["userName"] as? String,
            let businessName = record["businessName"] as? String,
            let businessTypeString = record["businessType"] as? String,
            let businessType = BusinessType(rawValue: businessTypeString),
            let collaborationTypeString = record["collaborationType"] as? String,
            let collaborationType = CollaborationType(rawValue: collaborationTypeString),
            let description = record["description"] as? String,
            let location = record["location"] as? String,
            let contactEmail = record["contactEmail"] as? String,
            let contactPhone = record["contactPhone"] as? String,
            let investmentRangeString = record["investmentRange"] as? String,
            let investmentRange = InvestmentRange(rawValue: investmentRangeString),
            let expectedROI = record["expectedROI"] as? String,
            let businessModel = record["businessModel"] as? String,
            let experienceRequired = record["experienceRequired"] as? String,
            let isVerified = record["isVerified"] as? Bool,
            let isPremium = record["isPremium"] as? Bool,
            let rating = record["rating"] as? Double,
            let reviewCount = record["reviewCount"] as? Int,
            let registrationDate = record["registrationDate"] as? Date,
            let statusString = record["status"] as? String,
            let status = CollaborationStatus(rawValue: statusString)
        else {
            return nil
        }
        
        return Collaboration(
            id: id,
            recordID: record.recordID,
            userID: userID,
            userName: userName,
            businessName: businessName,
            businessType: businessType,
            collaborationType: collaborationType,
            description: description,
            location: location,
            contactEmail: contactEmail,
            contactPhone: contactPhone,
            website: record["website"] as? String,
            logoImageURL: record["logoImageURL"] as? String,
            businessImages: record["businessImages"] as? [String] ?? [], // Default to empty array if nil
            investmentRange: investmentRange,
            expectedROI: expectedROI,
            businessModel: businessModel,
            experienceRequired: experienceRequired,
            supportProvided: record["supportProvided"] as? [String] ?? [], // Default to empty array if nil
            isVerified: isVerified,
            isPremium: isPremium,
            rating: rating,
            reviewCount: reviewCount,
            registrationDate: registrationDate,
            status: status
        )
    }
}

enum BusinessType: String, CaseIterable, Identifiable {
    case realEstate = "Real Estate"
    case propertyManagement = "Property Management"
    case construction = "Construction"
    case interiorDesign = "Interior Design"
    case propertyFinance = "Property Finance"
    case realEstateConsulting = "Real Estate Consulting"
    case propertyDevelopment = "Property Development"
    case propertyInvestment = "Property Investment"
    
    var id: String { self.rawValue }
}

enum CollaborationType: String, CaseIterable, Identifiable {
    case franchise = "Franchise"
    case partnership = "Partnership"
    case jointVenture = "Joint Venture"
    case investment = "Investment Opportunity"
    case distributorship = "Distributorship"
    case licensing = "Licensing"
    
    var id: String { self.rawValue }
}

enum InvestmentRange: String, CaseIterable, Identifiable {
    case under1Lakh = "Under ₹1 Lakh"
    case oneToFiveLakh = "₹1-5 Lakhs"
    case fiveToTenLakh = "₹5-10 Lakhs"
    case tenToTwentyLakh = "₹10-20 Lakhs"
    case twentyToFiftyLakh = "₹20-50 Lakhs"
    case fiftyLakhToOneCrore = "₹50 Lakhs - 1 Crore"
    case above1Crore = "Above ₹1 Crore"
    
    var id: String { self.rawValue }
}

enum CollaborationStatus: String, CaseIterable, Identifiable {
    case active = "Active"
    case inactive = "Inactive"
    case pending = "Pending"
    case suspended = "Suspended"
    
    var id: String { self.rawValue }
}

struct CollaborationRegistrationFormData {
    var businessName: String = ""
    var businessType: BusinessType = .realEstate
    var collaborationType: CollaborationType = .franchise
    var description: String = ""
    var location: String = ""
    var contactEmail: String = ""
    var contactPhone: String = ""
    var website: String = ""
    var logoImageURL: String = ""
    var businessImages: [String] = []
    var investmentRange: InvestmentRange = .under1Lakh
    var expectedROI: String = ""
    var businessModel: String = ""
    var experienceRequired: String = ""
    var supportProvided: Set<String> = []
}