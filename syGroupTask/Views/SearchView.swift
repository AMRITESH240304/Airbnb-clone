//
//  SearchView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var isSearching: Bool
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchHeaderView(isSearching: $isSearching, viewModel: viewModel)
                
                if viewModel.isShowingResults {
                    SearchResultsView(viewModel: viewModel)
                } else {
                    DefaultSearchView(viewModel: viewModel)
                }
            }
            .background(Color.gray.opacity(0.1))
            .onChange(of: viewModel.searchText) { _, newValue in
                viewModel.performSearch(query: newValue)
            }
            .onAppear {
                viewModel.setCloudkitViewModel(cloudkitViewModel)
                // Ensure properties are loaded
                if cloudkitViewModel.allProperties.isEmpty {
                    cloudkitViewModel.fetchAllListings()
                }
            }
        }
    }
}

// MARK: - Default Search View (when not searching)
struct DefaultSearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Search Bar
                SearchBarPlaceholder(viewModel: viewModel)
                
                // Recent Searches
                if !viewModel.recentSearches.isEmpty {
                    RecentSearchesSection(viewModel: viewModel)
                }
                
                // Suggested Categories
                SuggestedCategoriesSection(viewModel: viewModel)
                
                // Quick Filters
                QuickFiltersSection(viewModel: viewModel)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct SearchBarPlaceholder: View {
    @ObservedObject var viewModel: SearchViewModel
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.textSecondary)
                .font(.system(size: 18))
            
            TextField("Search properties, locations, categories...", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 16))
                .focused($isSearchFocused)
            
            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Recent Searches Section
struct RecentSearchesSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent searches")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Button("Clear all") {
                    viewModel.clearRecentSearches()
                }
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
            }
            
            VStack(spacing: 12) {
                ForEach(viewModel.recentSearches, id: \.self) { search in
                    RecentSearchRow(
                        icon: "clock",
                        iconColor: Theme.textSecondary,
                        title: search,
                        subtitle: "Recent search"
                    ) {
                        viewModel.selectRecentSearch(search)
                    }
                }
            }
        }
    }
}

// MARK: - Recent Search Row Component
struct RecentSearchRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Suggested Categories Section
struct SuggestedCategoriesSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    let categories = ["Apartment", "House", "Villa", "Office Space", "Shop", "Land"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Browse by category")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        viewModel.filterByCategory(category)
                    } label: {
                        HStack {
                            Text(category)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                    }
                }
            }
        }
    }
}

// MARK: - Quick Filters Section
struct QuickFiltersSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick filters")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 12) {
                Button {
                    viewModel.performNearbySearch()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Nearby Properties")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            Text("Find properties around you")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                }
                
                Button {
                    viewModel.filterByListingType(.forRent)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("For Rent")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            Text("Properties available for rent")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                }
                
                Button {
                    viewModel.filterByListingType(.forSale)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("For Sale")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            Text("Properties available for purchase")
                                .font(.system(size: 12))
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                }
            }
        }
    }
}

// MARK: - Search Results View
struct SearchResultsView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            SearchResultsHeader(viewModel: viewModel)
            SearchResultsContent(viewModel: viewModel)
        }
        .background(Theme.background)
    }
}

// MARK: - Search Results Header
struct SearchResultsHeader: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Search Field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.textSecondary)
                    .font(.system(size: 18))
                TextField("Search properties...", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16))
                
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            // Results count
            HStack {
                Text(viewModel.resultCount)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .background(Theme.background)
    }
}

// MARK: - Search Results Content
struct SearchResultsContent: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if viewModel.shouldShowNoResults {
            NoResultsView(searchQuery: viewModel.searchText)
        } else if viewModel.hasResults {
            SearchResultsList(viewModel: viewModel)
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            Text("Searching properties...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textSecondary)
            Spacer()
        }
        .padding()
    }
}

// MARK: - No Results View
struct NoResultsView: View {
    let searchQuery: String
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(Theme.textSecondary)
            Text("No properties found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            Text("Try searching for different keywords or check your spelling")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if !searchQuery.isEmpty {
                Text("Searched for: \"\(searchQuery)\"")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                    .italic()
                    .padding(.top, 8)
            }
            Spacer()
        }
        .padding()
    }
}

// MARK: - Search Results List
struct SearchResultsList: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.searchResults) { property in
                    NavigationLink {
                        PropertyDetailView(property: property)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        PropertyListItemView(property: property)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

#Preview {
    SearchView(isSearching: .constant(true))
        .environmentObject(CloudkitManagerViewModel())
}
