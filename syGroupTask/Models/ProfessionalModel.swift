import Foundation
import CloudKit

struct Professional: Identifiable, Equatable {
    var id: UUID
    var recordID: CKRecord.ID?
    
    var userID: String
    var userName: String
    var businessName: String
    var description: String
    var phoneNumber: String
    var email: String
    var location: String
    var website: String?
    
    var services: [ProfessionalService]
    var categories: [ServiceCategory]
    var experience: Int
    var profileImageURL: String?
    var portfolioImages: [String]
    
    var rating: Double
    var reviewCount: Int
    var isVerified: Bool
    var isPremium: Bool
    
    var registrationDate: Date
    var subscriptionEndDate: Date?
    var status: ProfessionalStatus
    
    func toCKRecord() -> CKRecord {
        let record: CKRecord
        
        if let recordID = self.recordID {
            record = CKRecord(recordType: "Professional", recordID: recordID)
        } else {
            record = CKRecord(recordType: "Professional")
        }
        
        record["id"] = id.uuidString
        record["userID"] = userID
        record["userName"] = userName
        record["businessName"] = businessName
        record["description"] = description
        record["phoneNumber"] = phoneNumber
        record["email"] = email
        record["location"] = location
        
        if let website = website, !website.isEmpty {
            record["website"] = website
        }
        
        if !services.isEmpty {
            if let servicesData = try? JSONEncoder().encode(services) {
                record["servicesData"] = servicesData
            }
        }
        
        record["categoriesData"] = categories.map { $0.rawValue }
        
        record["experience"] = experience
        
        if let profileImageURL = profileImageURL, !profileImageURL.isEmpty {
            record["profileImageURL"] = profileImageURL
        }
        
        if !portfolioImages.isEmpty {
            record["portfolioImages"] = portfolioImages
        }
        
        record["rating"] = rating
        record["reviewCount"] = reviewCount
        record["isVerified"] = isVerified
        record["isPremium"] = isPremium
        record["registrationDate"] = registrationDate
        
        if let subscriptionEndDate = subscriptionEndDate {
            record["subscriptionEndDate"] = subscriptionEndDate
        }
        
        record["status"] = status.rawValue
        
        return record
    }
    
    static func fromCKRecord(_ record: CKRecord) -> Professional? {
        guard
            let idString = record["id"] as? String,
            let id = UUID(uuidString: idString),
            let userID = record["userID"] as? String,
            let userName = record["userName"] as? String,
            let businessName = record["businessName"] as? String,
            let description = record["description"] as? String,
            let phoneNumber = record["phoneNumber"] as? String,
            let email = record["email"] as? String,
            let location = record["location"] as? String,
            let experience = record["experience"] as? Int,
            let rating = record["rating"] as? Double,
            let reviewCount = record["reviewCount"] as? Int,
            let isVerified = record["isVerified"] as? Bool,
            let isPremium = record["isPremium"] as? Bool,
            let registrationDate = record["registrationDate"] as? Date,
            let statusRaw = record["status"] as? String,
            let status = ProfessionalStatus(rawValue: statusRaw)
        else {
            return nil
        }
        
        let website = record["website"] as? String
        let profileImageURL = record["profileImageURL"] as? String
        let portfolioImages = record["portfolioImages"] as? [String] ?? []
        let subscriptionEndDate = record["subscriptionEndDate"] as? Date
        
        var services: [ProfessionalService] = []
        if let servicesData = record["servicesData"] as? Data {
            services = (try? JSONDecoder().decode([ProfessionalService].self, from: servicesData)) ?? []
        }
        
        var categories: [ServiceCategory] = []
        if let categoriesData = record["categoriesData"] as? [String] {
            categories = categoriesData.compactMap { ServiceCategory(rawValue: $0) }
        }
        
        return Professional(
            id: id,
            recordID: record.recordID,
            userID: userID,
            userName: userName,
            businessName: businessName,
            description: description,
            phoneNumber: phoneNumber,
            email: email,
            location: location,
            website: website,
            services: services,
            categories: categories,
            experience: experience,
            profileImageURL: profileImageURL,
            portfolioImages: portfolioImages,
            rating: rating,
            reviewCount: reviewCount,
            isVerified: isVerified,
            isPremium: isPremium,
            registrationDate: registrationDate,
            subscriptionEndDate: subscriptionEndDate,
            status: status
        )
    }
}

struct ProfessionalService: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var price: Double
    var duration: String 
    var category: ServiceCategory
    
    init(id: UUID = UUID(), name: String, description: String, price: Double, duration: String, category: ServiceCategory) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.duration = duration
        self.category = category
    }
}

enum ServiceCategory: String, CaseIterable, Identifiable, Codable {
    case realEstate = "Real Estate"
    case architecture = "Architecture"
    case interiorDesign = "Interior Design"
    case construction = "Construction"
    case legalServices = "Legal Services"
    case financialServices = "Financial Services"
    case photography = "Photography"
    case propertyManagement = "Property Management"
    case homeInspection = "Home Inspection"
    case cleaning = "Cleaning Services"
    case security = "Security Services"
    case landscaping = "Landscaping"
    case maintenance = "Maintenance"
    case moving = "Moving Services"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .realEstate: return "house.fill"
        case .architecture: return "building.2.fill"
        case .interiorDesign: return "paintbrush.fill"
        case .construction: return "hammer.fill"
        case .legalServices: return "briefcase.fill"
        case .financialServices: return "dollarsign.circle.fill"
        case .photography: return "camera.fill"
        case .propertyManagement: return "key.fill"
        case .homeInspection: return "magnifyingglass"
        case .cleaning: return "sparkles"
        case .security: return "shield.fill"
        case .landscaping: return "leaf.fill"
        case .maintenance: return "wrench.fill"
        case .moving: return "shippingbox.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
}

enum ProfessionalStatus: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case active = "Active"
    case suspended = "Suspended"
    case inactive = "Inactive"
    
    var id: String { self.rawValue }
}

struct ProfessionalRegistrationFormData {
    var businessName: String = ""
    var description: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var location: String = ""
    var website: String = ""
    var experience: String = ""
    var selectedCategories: Set<ServiceCategory> = []
    var services: [ProfessionalService] = []
    var profileImageURL: String = ""
    var portfolioImages: [String] = []
    var agreedToTerms: Bool = false
}
