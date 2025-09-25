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
    @Published var selectedFilter: String = "Real Estate"
    @Published var isLoading = false
    
    private let imageCache = ImageCacheManager.shared
    
    let filters = ["Real Estate", "Professionals", "Services"]
    
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
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            preloadImages()
            
            isLoading = false
        }
    }
    
    // MARK: - Image Preloading
    
    private func preloadImages() {
        Task {
            let allImageUrls = getAllImageUrls()
            
            imageCache.preloadImages(allImageUrls)
        }
    }
    
    private func preloadImagesForCurrentFilter() {
        Task {
            let imageUrls: [String]
            
            switch selectedFilter {
            case "Real Estate":
                imageUrls = getHomesImageUrls()
            case "Professionals":
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
        
        urls.append(contentsOf: getHomesImageUrls())
        urls.append(contentsOf: getExperienceImageUrls())
        urls.append(contentsOf: getServicesImageUrls())
        
        return urls
    }
    
    private func getHomesImageUrls() -> [String] {
        var urls: [String] = []
        
        urls.append(contentsOf: MockData.sampleCards.compactMap { $0.imageURL })
        
        urls.append(contentsOf: MockData.availableForSimilarDates.compactMap { $0.imageURL })
        
        urls.append(contentsOf: MockData.stayInPuducherry.compactMap { $0.imageURL })
        
        urls.append(contentsOf: MockData.stayInParis.compactMap { $0.imageURL })
        
        return urls
    }
    
    private func getExperienceImageUrls() -> [String] {
        var urls: [String] = []
        
        urls.append(contentsOf: MockData.airbnbOriginals.compactMap { $0.imageURL })
        
        urls.append(contentsOf: MockData.photographyExperiences.compactMap { $0.imageURL })
        
        urls.append(contentsOf: MockData.allExperiencesPondicherry.compactMap { $0.imageURL })
        
        return urls
    }
    
    private func getServicesImageUrls() -> [String] {
        var urls: [String] = []
        
        urls.append(contentsOf: MockData.servicesInPromenadeBeach.compactMap { $0.imageURL })
        
        urls.append(contentsOf: MockData.photographyExperiences.compactMap { $0.imageURL })
        
        return urls
    }
}
