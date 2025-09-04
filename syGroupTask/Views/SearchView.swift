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
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top section with close button
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
        }
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
            }
            
            VStack(spacing: 16) {
                RecentSearchRow(
                    icon: "mappin.circle.fill",
                    iconColor: Theme.textSecondary,
                    title: "Promenade Beach",
                    subtitle: "5–7 Sept"
                ) {
                    viewModel.selectRecentSearch("Promenade Beach")
                }
                
                RecentSearchRow(
                    icon: "building.2.fill",
                    iconColor: .green,
                    title: "Puducherry",
                    subtitle: "5–7 Sept"
                ) {
                    viewModel.selectRecentSearch("Puducherry")
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
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                }
                Spacer()
            }
        }
    }
}

// MARK: - Suggested Destinations Section
struct SuggestedDestinationsSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Suggested destinations")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
            }
            
            Button {
                viewModel.performNearbySearch()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Nearby")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                        Text("Find what's around you")
                            .font(.system(size: 14))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                }
            }
            
            Button {
                viewModel.selectRecentSearch("Puducherry")
            } label: {
                HStack(spacing: 12) {
                    Spacer()
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Puducherry, Puducherry")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Date and Guest Section
struct DateAndGuestSection: View {
    var body: some View {
        VStack(spacing: 12) {
            // When section
            HStack {
                Text("When")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("Add dates")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textPrimary)
            }
            .padding()
            .background(Theme.background)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            
            // Who section
            HStack {
                Text("Who")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("Add guests")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textPrimary)
            }
            .padding()
            .background(Theme.background)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Search Footer Section
struct SearchFooterSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        HStack {
            Button("Clear all") {
                viewModel.clearSearch()
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(Theme.textPrimary)
            .underline()
            
            Spacer()
            
            Button {
                if !viewModel.searchText.isEmpty {
                    viewModel.performSearch(query: viewModel.searchText)
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                    Text("Search")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(Theme.textLight)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Theme.primaryColor)
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
    }
}

// MARK: - Search Results View
struct SearchResultsView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            SearchResultsHeader(viewModel: viewModel)
            SearchResultsContent(viewModel: viewModel)
            Spacer()
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
                TextField("Search destinations", text: $viewModel.searchText)
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
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
            
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
            NoResultsView()
        } else if viewModel.hasResults {
            SearchResultsGrid(viewModel: viewModel)
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
            Text("Searching...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textSecondary)
            Spacer()
        }
        .padding()
    }
}

// MARK: - No Results View
struct NoResultsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(Theme.textSecondary)
            Text("No places found")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            Text("Try searching for a different location")
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
            Spacer()
        }
        .padding()
    }
}

// MARK: - Search Results Grid
struct SearchResultsGrid: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 16) {
                ForEach(viewModel.searchResults) { card in
                    NavigationLink {
                        CardsDetailView(cardId: card.id)
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        SearchResultCard(card: card)
                    }
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
}
