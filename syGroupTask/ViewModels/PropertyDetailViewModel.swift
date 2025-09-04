//
//  PropertyDetailViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 04/09/25.
//

import Foundation
import SwiftUI

@MainActor
class PropertyDetailViewModel: ObservableObject {
    @Published var propertyDetail: PropertyDetail
    @Published var isLoading = false
    @Published var currentImageIndex = 0
    
    private let cardId: UUID
    private let imageCache = ImageCacheManager.shared
    
    init(cardId: UUID) {
        self.cardId = cardId
        self.propertyDetail = MockData.getPropertyDetailOrDefault(for: cardId)
        
        preloadPropertyImages()
    }
    
    // MARK: - Public Methods
    
    func refreshPropertyData() {
        isLoading = true
        
        Task {
            // Simulate data refresh
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second
            
            // Reload property details
            propertyDetail = MockData.getPropertyDetailOrDefault(for: cardId)
            
            // Preload images after refresh
            preloadPropertyImages()
            
            isLoading = false
        }
    }
    
    func nextImage() {
        let nextIndex = (currentImageIndex + 1) % propertyDetail.images.count
        currentImageIndex = nextIndex
    }
    
    func previousImage() {
        let previousIndex = currentImageIndex > 0 ? currentImageIndex - 1 : propertyDetail.images.count - 1
        currentImageIndex = previousIndex
    }
    
    func selectImage(at index: Int) {
        guard index >= 0 && index < propertyDetail.images.count else { return }
        currentImageIndex = index
    }
    
    func getAmenityIcon(_ amenity: String) -> String {
        switch amenity.lowercased() {
        case "wifi": return "wifi"
        case "kitchen": return "fork.knife"
        case "air conditioning": return "snow"
        case "pool": return "figure.pool.swim"
        case "free parking", "parking": return "car.fill"
        case "tv": return "tv.fill"
        case "washer": return "washinmachine.fill"
        case "iron": return "iron.fill"
        case "beach access": return "beach.umbrella.fill"
        case "hot tub": return "bathtub.fill"
        case "bbq grill": return "flame.fill"
        case "mountain view": return "mountain.2.fill"
        case "fireplace": return "flame.fill"
        case "heating": return "thermometer.sun.fill"
        case "garden": return "leaf.fill"
        case "hiking trails": return "figure.hiking"
        case "shared kitchen": return "fork.knife"
        case "meditation space": return "leaf.fill"
        case "bicycle": return "bicycle"
        case "breakfast": return "cup.and.saucer.fill"
        case "terrace": return "building.2.fill"
        default: return "checkmark.circle.fill"
        }
    }
    
    // MARK: - Private Methods
    
    private func preloadPropertyImages() {
        Task {
            // Preload all property images
            let imageUrls = propertyDetail.images
            imageCache.preloadImages(imageUrls)
            
            // Also preload host profile image
            imageCache.preloadImages([propertyDetail.host.profileImage])
        }
    }
}
