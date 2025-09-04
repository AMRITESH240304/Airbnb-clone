//
//  ExploreViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 04/09/25.
//

import Foundation
import SwiftUI

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var selectedFilter: String = "Homes"
    @Published var isLoading = false
    
    private let imageCache = ImageCacheManager.shared
    
    let filters = ["Homes", "Experience", "Services"]
    
    init() {
        preloadImages()
    }
    
    // MARK: - Public Methods
    
    func setSelectedFilter(_ filter: String) {
        selectedFilter = filter
        preloadImagesForCurrentFilter()
    }
    
    func refreshData() {
        isLoading = true
        
        Task {
            // Simulate data refresh
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
            
            // Preload images after refresh
            preloadImages()
            
            isLoading = false
        }
    }
    
    // MARK: - Image Preloading
    
    private func preloadImages() {
        Task {
            // Collect all image URLs from current data
            let allImageUrls = getAllImageUrls()
            
            // Preload images in background
            imageCache.preloadImages(allImageUrls)
        }
    }
    
    private func preloadImagesForCurrentFilter() {
        Task {
            let imageUrls: [String]
            
            switch selectedFilter {
            case "Homes":
                imageUrls = getHomesImageUrls()
            case "Experience":
                imageUrls = getExperienceImageUrls()
            case "Services":
                imageUrls = getServicesImageUrls()
            default:
                imageUrls = []
            }
            
            imageCache.preloadImages(imageUrls)
        }
    }
    
    private func getAllImageUrls() -> [String] {
        var urls: [String] = []
        
        // Add URLs from all sections
        urls.append(contentsOf: getHomesImageUrls())
        urls.append(contentsOf: getExperienceImageUrls())
        urls.append(contentsOf: getServicesImageUrls())
        
        return urls
    }
    
    private func getHomesImageUrls() -> [String] {
        var urls: [String] = []
        
        // Sample cards
        urls.append(contentsOf: MockData.sampleCards.compactMap { $0.imageURL })
        
        // Available for similar dates
        urls.append(contentsOf: MockData.availableForSimilarDates.compactMap { $0.imageURL })
        
        // Stay in Puducherry
        urls.append(contentsOf: MockData.stayInPuducherry.compactMap { $0.imageURL })
        
        // Stay in Paris
        urls.append(contentsOf: MockData.stayInParis.compactMap { $0.imageURL })
        
        return urls
    }
    
    private func getExperienceImageUrls() -> [String] {
        var urls: [String] = []
        
        // Airbnb Originals
        urls.append(contentsOf: MockData.airbnbOriginals.compactMap { $0.imageURL })
        
        // Photography experiences
        urls.append(contentsOf: MockData.photographyExperiences.compactMap { $0.imageURL })
        
        // All experiences in Pondicherry
        urls.append(contentsOf: MockData.allExperiencesPondicherry.compactMap { $0.imageURL })
        
        return urls
    }
    
    private func getServicesImageUrls() -> [String] {
        var urls: [String] = []
        
        // Services
        urls.append(contentsOf: MockData.servicesInPromenadeBeach.compactMap { $0.imageURL })
        
        // Photography (services tab)
        urls.append(contentsOf: MockData.photographyExperiences.compactMap { $0.imageURL })
        
        return urls
    }
}
