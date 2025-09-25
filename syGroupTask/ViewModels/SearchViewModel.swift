//
//  SearchViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [PropertyListing] = []
    @Published var isShowingResults: Bool = false
    @Published var isLoading: Bool = false
    @Published var recentSearches: [String] = []
    
    private var cloudkitViewModel: CloudkitManagerViewModel?
    
    func setCloudkitViewModel(_ viewModel: CloudkitManagerViewModel) {
        self.cloudkitViewModel = viewModel
    }
    
    // MARK: - Search Functions
    func performSearch(query: String) {
        guard let cloudkitViewModel = cloudkitViewModel else { return }
        
        if query.isEmpty {
            clearSearchResults()
            return
        }
        
        isLoading = true
        isShowingResults = true
        
        if !recentSearches.contains(query) {
            recentSearches.insert(query, at: 0)
            if recentSearches.count > 5 {
                recentSearches.removeLast()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.executeSearch(query: query, properties: cloudkitViewModel.allProperties)
            self.isLoading = false
        }
    }
    
    private func executeSearch(query: String, properties: [PropertyListing]) {
        let lowercasedQuery = query.lowercased()
        
        searchResults = properties.filter { property in
            property.title.localizedCaseInsensitiveContains(query) ||
            property.location.localizedCaseInsensitiveContains(query) ||
            property.category.localizedCaseInsensitiveContains(query) ||
            property.description.localizedCaseInsensitiveContains(query) ||
            property.ownerName.localizedCaseInsensitiveContains(query) ||
            property.listingType.rawValue.localizedCaseInsensitiveContains(query)
        }
        
        searchResults.sort { property1, property2 in
            let title1Match = property1.title.localizedCaseInsensitiveContains(query)
            let title2Match = property2.title.localizedCaseInsensitiveContains(query)
            
            if title1Match && !title2Match {
                return true
            } else if !title1Match && title2Match {
                return false
            }
            
            let location1Match = property1.location.localizedCaseInsensitiveContains(query)
            let location2Match = property2.location.localizedCaseInsensitiveContains(query)
            
            if location1Match && !location2Match {
                return true
            } else if !location1Match && location2Match {
                return false
            }
            
            return property1.listingDate > property2.listingDate
        }
    }
    
    func performNearbySearch() {
        guard let cloudkitViewModel = cloudkitViewModel else { return }
        
        isShowingResults = true
        searchText = "Nearby"
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchResults = cloudkitViewModel.allProperties.filter { $0.status == .active }
            self.isLoading = false
        }
    }
    
    func selectRecentSearch(_ searchTerm: String) {
        searchText = searchTerm
        performSearch(query: searchTerm)
    }
    
    func clearSearch() {
        searchText = ""
        clearSearchResults()
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
    }
    
    private func clearSearchResults() {
        searchResults = []
        isShowingResults = false
        isLoading = false
    }
    
    // MARK: - Filter Functions
    func filterByCategory(_ category: String) {
        guard let cloudkitViewModel = cloudkitViewModel else { return }
        
        isShowingResults = true
        searchText = category
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchResults = cloudkitViewModel.allProperties.filter { 
                $0.category.localizedCaseInsensitiveContains(category) && $0.status == .active
            }
            self.isLoading = false
        }
    }
    
    func filterByListingType(_ listingType: ListingType) {
        guard let cloudkitViewModel = cloudkitViewModel else { return }
        
        isShowingResults = true
        searchText = listingType.rawValue
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchResults = cloudkitViewModel.allProperties.filter { 
                $0.listingType == listingType && $0.status == .active
            }
            self.isLoading = false
        }
    }
    
    // MARK: - Computed Properties
    var resultCount: String {
        if searchResults.count == 1 {
            return "1 property found"
        } else {
            return "\(searchResults.count) properties found"
        }
    }
    
    var hasResults: Bool {
        return !searchResults.isEmpty
    }
    
    var shouldShowNoResults: Bool {
        return !hasResults && isShowingResults && !isLoading
    }
}
