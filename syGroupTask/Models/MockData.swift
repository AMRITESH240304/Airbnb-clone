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

struct MockData {
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
}
