//
//  MockData.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import Foundation

struct CardModel: Identifiable {
    let id = UUID()
    let flatName: String
    let cost: String
    let rating: Double
    let label: String
    let imageName: String
    var isLiked: Bool = false
}

struct RecentlyViewedProperty: Identifiable {
    let id = UUID()
    let title: String
    let details: String
    let rating: Double
    let imageURL: String
}

struct ServiceItem: Identifiable {
    let id = UUID()
    let name: String
    let availability: String
    let imageName: String
}

// New detailed model for card details view
struct PropertyDetail: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let location: String
    let images: [String]
    let rating: Double
    let reviewCount: Int
    let isGuestFavourite: Bool
    let host: HostInfo
    let amenities: [String]
    let description: String
    let pricePerNight: Int
    let currency: String
    let totalPrice: Int
    let nights: Int
    let checkIn: String
    let checkOut: String
    let maxGuests: Int
    let bedrooms: Int
    let bathrooms: Int
    let propertyType: String
}

struct HostInfo: Identifiable {
    let id = UUID()
    let name: String
    let profileImage: String
    let hostingSince: String
    let responseRate: String
    let responseTime: String
    let isSuperhost: Bool
}

struct MockData {
    
    // Create shared UUIDs for consistent mapping
    private static let puducherryFlatId = UUID()
    private static let goaVillaId = UUID()
    private static let manaliCabinId = UUID()
    private static let aurovilleRoomId = UUID()
    private static let puducherryFlat2Id = UUID()
    private static let chennaiRoomId = UUID()
    private static let puducherryGuestHouseId = UUID()
    private static let puducherryGuestSuiteId = UUID()
    private static let parisApartmentId = UUID()
    private static let montmartreStudioId = UUID()
    private static let maraisLoftId = UUID()
    
    static let sampleCards: [CardModel] = [
        CardModel(flatName: "Flat in Puducherry",
                  cost: "₹3,251 for 2 nights",
                  rating: 4.83,
                  label: "Guest favourite",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Villa in Goa",
                  cost: "₹6,500 for 3 nights",
                  rating: 4.95,
                  label: "Top rated",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Cabin in Manali",
                  cost: "₹4,200 for 2 nights",
                  rating: 4.76,
                  label: "Mountain view",
                  imageName: "sample_cabin")
    ]
    
    // Available for similar dates section
    static let availableForSimilarDates: [CardModel] = [
        CardModel(flatName: "Room in Auroville",
                  cost: "₹2,009 for 2 nights",
                  rating: 4.85,
                  label: "Guest favourite",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Flat in Puducherry",
                  cost: "₹10,271 for 2 nights",
                  rating: 4.89,
                  label: "Guest favourite",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Room in Chennai",
                  cost: "₹7,500 for 2 nights",
                  rating: 4.92,
                  label: "Guest favourite",
                  imageName: "sample_cabin")
    ]
    
    // Stay in Puducherry section
    static let stayInPuducherry: [CardModel] = [
        CardModel(flatName: "Flat in Puducherry",
                  cost: "₹3,251 for 2 nights",
                  rating: 4.83,
                  label: "Guest favourite",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Guest house in Puducherry",
                  cost: "₹3,424 for 2 nights",
                  rating: 4.84,
                  label: "Guest favourite",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Guest suite in Puducherry",
                  cost: "₹4,200 for 2 nights",
                  rating: 4.91,
                  label: "Guest favourite",
                  imageName: "sample_cabin")
    ]
    
    // Stay in Paris section
    static let stayInParis: [CardModel] = [
        CardModel(flatName: "Apartment in Paris",
                  cost: "€89 for 2 nights",
                  rating: 4.88,
                  label: "Superhost",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Studio in Montmartre",
                  cost: "€120 for 2 nights",
                  rating: 4.92,
                  label: "Guest favourite",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Loft in Le Marais",
                  cost: "€150 for 2 nights",
                  rating: 4.95,
                  label: "Rare find",
                  imageName: "sample_cabin")
    ]
    
    // Experience sections
    static let airbnbOriginals: [CardModel] = [
        CardModel(flatName: "Lunch with fashion icon Lenny Niemeyer in her atelier",
                  cost: "From ₹9,226 / guest",
                  rating: 4.95,
                  label: "Original",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Create seasonal ikebana with Watarai Toru",
                  cost: "From ₹8,573 / guest",
                  rating: 5.0,
                  label: "Original",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Hit the spa in Paris",
                  cost: "From ₹12,500 / guest",
                  rating: 4.88,
                  label: "Original",
                  imageName: "sample_cabin")
    ]
    
    static let photographyExperiences: [CardModel] = [
        CardModel(flatName: "Stylish vintage car photo shoot Tour",
                  cost: "From ₹6,162 / guest",
                  rating: 4.89,
                  label: "Popular",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Photo session at the Metropolitan Museum",
                  cost: "From ₹26,422 / guest",
                  rating: 5.0,
                  label: "Rare find",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Sunrise photography at the Golden Gate",
                  cost: "From ₹8,500 / guest",
                  rating: 4.95,
                  label: "Popular",
                  imageName: "sample_cabin")
    ]
    
    static let allExperiencesPondicherry: [CardModel] = [
        CardModel(flatName: "Heritage cycle tour of Pondicherry",
                  cost: "From ₹999 / guest",
                  rating: 4.91,
                  label: "Popular",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Kayak Pondicherry's mangroves with a travel expert",
                  cost: "From ₹950 / guest",
                  rating: 4.93,
                  label: "Popular",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Underwater photography experience",
                  cost: "From ₹1,200 / guest",
                  rating: 4.87,
                  label: "New",
                  imageName: "sample_cabin")
    ]
    
    // Services
    static let servicesInPromenadeBeach: [ServiceItem] = [
        ServiceItem(name: "Massage", availability: "1 available", imageName: "sample_room"),
        ServiceItem(name: "Photography", availability: "Coming soon", imageName: "sample_villa"),
        ServiceItem(name: "Chefs", availability: "Coming soon", imageName: "sample_cabin"),
        ServiceItem(name: "Private dining", availability: "Coming soon", imageName: "sample_room")
    ]
    
    // Recently viewed properties
    static let todayViewed: [RecentlyViewedProperty] = [
        RecentlyViewedProperty(
            title: "Rental unit in Puducherry",
            details: "2 beds",
            rating: 4.75,
            imageURL: "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=300&h=200&fit=crop"
        )
    ]
    
    static let previousDayViewed: [RecentlyViewedProperty] = [
        RecentlyViewedProperty(
            title: "Room in Thiruvananthapuram",
            details: "2 beds",
            rating: 4.92,
            imageURL: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=300&h=200&fit=crop"
        ),
        RecentlyViewedProperty(
            title: "Home in Coimbatore district",
            details: "4 beds",
            rating: 5.0,
            imageURL: "https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=300&h=200&fit=crop"
        )
    ]
    
    // MARK: - Property Details Mock Data
    static let propertyDetails: [UUID: PropertyDetail] = createPropertyDetailsMap()
    
    private static func createPropertyDetailsMap() -> [UUID: PropertyDetail] {
        
        let propertyDetailsList: [(UUID, PropertyDetail)] = [
            // Link to sampleCards[0] - Flat in Puducherry
            (sampleCards[0].id, PropertyDetail(
                title: "Cozy Heritage Villa",
                subtitle: "Entire villa in Puducherry",
                location: "White Town, Puducherry, India",
                images: ["house1", "house2", "house3", "house4", "house5"],
                rating: 4.83,
                reviewCount: 127,
                isGuestFavourite: true,
                host: HostInfo(
                    name: "Priya",
                    profileImage: "host1",
                    hostingSince: "2018",
                    responseRate: "100%",
                    responseTime: "within an hour",
                    isSuperhost: true
                ),
                amenities: ["WiFi", "Kitchen", "Air conditioning", "Pool", "Free parking", "TV", "Washer", "Iron"],
                description: "Escape to this charming heritage villa nestled in the heart of Puducherry's French Quarter. This beautifully restored colonial home combines old-world charm with modern amenities. Wake up to the gentle sea breeze and enjoy your morning coffee in the lush garden courtyard.",
                pricePerNight: 1625,
                currency: "₹",
                totalPrice: 3251,
                nights: 2,
                checkIn: "15 Sep",
                checkOut: "17 Sep",
                maxGuests: 4,
                bedrooms: 2,
                bathrooms: 2,
                propertyType: "Villa"
            )),
            
            // Link to sampleCards[1] - Villa in Goa
            (sampleCards[1].id, PropertyDetail(
                title: "Luxury Beach Villa",
                subtitle: "Entire villa in Goa",
                location: "Anjuna Beach, Goa, India",
                images: ["house2", "house3", "house1", "house4", "house5"],
                rating: 4.95,
                reviewCount: 89,
                isGuestFavourite: true,
                host: HostInfo(
                    name: "Raj",
                    profileImage: "host2",
                    hostingSince: "2016",
                    responseRate: "98%",
                    responseTime: "within a few hours",
                    isSuperhost: true
                ),
                amenities: ["Beach access", "Pool", "WiFi", "Kitchen", "Air conditioning", "Parking", "Hot tub", "BBQ grill"],
                description: "Stunning beachfront villa with panoramic ocean views. Perfect for families and groups looking for luxury and comfort. Direct beach access and world-class amenities make this the perfect Goa getaway.",
                pricePerNight: 2167,
                currency: "₹",
                totalPrice: 6500,
                nights: 3,
                checkIn: "20 Sep",
                checkOut: "23 Sep",
                maxGuests: 8,
                bedrooms: 4,
                bathrooms: 3,
                propertyType: "Villa"
            )),
            
            // Link to sampleCards[2] - Cabin in Manali
            (sampleCards[2].id, PropertyDetail(
                title: "Mountain Retreat Cabin",
                subtitle: "Entire cabin in Manali",
                location: "Old Manali, Himachal Pradesh, India",
                images: ["house3", "house1", "house2", "house4", "house5"],
                rating: 4.76,
                reviewCount: 156,
                isGuestFavourite: false,
                host: HostInfo(
                    name: "Ankit",
                    profileImage: "host3",
                    hostingSince: "2019",
                    responseRate: "95%",
                    responseTime: "within a day",
                    isSuperhost: false
                ),
                amenities: ["Mountain view", "Fireplace", "WiFi", "Kitchen", "Heating", "Parking", "Garden", "Hiking trails"],
                description: "Cozy wooden cabin surrounded by pine forests and snow-capped mountains. Perfect for couples or small families seeking adventure and tranquility. Enjoy hiking trails, local markets, and breathtaking Himalayan views.",
                pricePerNight: 2100,
                currency: "₹",
                totalPrice: 4200,
                nights: 2,
                checkIn: "25 Sep",
                checkOut: "27 Sep",
                maxGuests: 4,
                bedrooms: 2,
                bathrooms: 1,
                propertyType: "Cabin"
            )),
            
            // Link to availableForSimilarDates[0] - Room in Auroville
            (availableForSimilarDates[0].id, PropertyDetail(
                title: "Peaceful Auroville Room",
                subtitle: "Private room in Auroville",
                location: "Auroville, Tamil Nadu, India",
                images: ["house4", "house5", "house1", "house2", "house3"],
                rating: 4.85,
                reviewCount: 73,
                isGuestFavourite: true,
                host: HostInfo(
                    name: "Maya",
                    profileImage: "host1",
                    hostingSince: "2017",
                    responseRate: "100%",
                    responseTime: "within an hour",
                    isSuperhost: false
                ),
                amenities: ["WiFi", "Shared kitchen", "Garden", "Meditation space", "Bicycle", "Breakfast"],
                description: "Experience the tranquil atmosphere of Auroville in this peaceful room. Perfect for spiritual seekers and those looking to disconnect from the busy world. Enjoy organic meals and participate in community activities.",
                pricePerNight: 1005,
                currency: "₹",
                totalPrice: 2009,
                nights: 2,
                checkIn: "18 Sep",
                checkOut: "20 Sep",
                maxGuests: 2,
                bedrooms: 1,
                bathrooms: 1,
                propertyType: "Room"
            )),
            
            // Add more property details for other cards...
            (stayInPuducherry[1].id, PropertyDetail(
                title: "Traditional Guest House",
                subtitle: "Guest house in Puducherry",
                location: "Tamil Quarter, Puducherry, India",
                images: ["house5", "house1", "house2", "house3", "house4"],
                rating: 4.84,
                reviewCount: 92,
                isGuestFavourite: true,
                host: HostInfo(
                    name: "Kumar",
                    profileImage: "host2",
                    hostingSince: "2015",
                    responseRate: "98%",
                    responseTime: "within 2 hours",
                    isSuperhost: true
                ),
                amenities: ["WiFi", "Kitchen", "Air conditioning", "Terrace", "Free parking", "Garden"],
                description: "Stay in this charming traditional guest house that offers an authentic South Indian experience. Located in the heart of the Tamil Quarter, you'll be immersed in local culture while enjoying modern comforts.",
                pricePerNight: 1712,
                currency: "₹",
                totalPrice: 3424,
                nights: 2,
                checkIn: "22 Sep",
                checkOut: "24 Sep",
                maxGuests: 6,
                bedrooms: 3,
                bathrooms: 2,
                propertyType: "Guest house"
            ))
        ]
        
        return Dictionary(uniqueKeysWithValues: propertyDetailsList)
    }
    
    // Helper function to get property detail by card ID
    static func getPropertyDetail(for cardId: UUID) -> PropertyDetail? {
        return propertyDetails[cardId]
    }
    
    // Alternative function that returns a default property detail
    static func getPropertyDetailOrDefault(for cardId: UUID) -> PropertyDetail {
        return propertyDetails[cardId] ?? PropertyDetail(
            title: "Beautiful Property",
            subtitle: "Entire place",
            location: "Location, India",
            images: ["house1", "house2", "house3"],
            rating: 4.5,
            reviewCount: 50,
            isGuestFavourite: true,
            host: HostInfo(
                name: "Host",
                profileImage: "host1",
                hostingSince: "2020",
                responseRate: "100%",
                responseTime: "within an hour",
                isSuperhost: false
            ),
            amenities: ["WiFi", "Kitchen", "Air conditioning"],
            description: "A wonderful place to stay with all modern amenities and great hospitality.",
            pricePerNight: 2000,
            currency: "₹",
            totalPrice: 4000,
            nights: 2,
            checkIn: "Check in",
            checkOut: "Check out",
            maxGuests: 4,
            bedrooms: 2,
            bathrooms: 2,
            propertyType: "House"
        )
    }
}
