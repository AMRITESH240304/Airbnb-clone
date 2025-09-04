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
    @Published var searchResults: [CardModel] = []
    @Published var isShowingResults: Bool = false
    @Published var isLoading: Bool = false
    
    // MARK: - Search Functions
    func performSearch(query: String) {
        if query.isEmpty {
            clearSearchResults()
            return
        }
        
        isLoading = true
        isShowingResults = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.executeSearch(query: query)
            self.isLoading = false
        }
    }
    
    private func executeSearch(query: String) {
        // Combine all available cards for searching
        let allCards = MockData.sampleCards +
                      MockData.availableForSimilarDates +
                      MockData.stayInPuducherry +
                      MockData.stayInParis
        
        // Filter cards based on search query
        searchResults = allCards.filter { card in
            card.flatName.localizedCaseInsensitiveContains(query) ||
            card.location.localizedCaseInsensitiveContains(query) ||
            card.label.localizedCaseInsensitiveContains(query)
        }
    }
    
    func performNearbySearch() {
        isShowingResults = true
        searchText = "Nearby"
        
        // Show local Puducherry properties for "nearby" search
        searchResults = MockData.stayInPuducherry + [MockData.sampleCards[0]]
    }
    
    func selectRecentSearch(_ searchTerm: String) {
        searchText = searchTerm
        performSearch(query: searchTerm)
    }
    
    func clearSearch() {
        searchText = ""
        clearSearchResults()
    }
    
    private func clearSearchResults() {
        searchResults = []
        isShowingResults = false
        isLoading = false
    }
    
    // MARK: - Computed Properties
    var resultCount: String {
        return "\(searchResults.count) places found"
    }
    
    var hasResults: Bool {
        return !searchResults.isEmpty
    }
    
    var shouldShowNoResults: Bool {
        return !hasResults && isShowingResults && !isLoading
    }
}