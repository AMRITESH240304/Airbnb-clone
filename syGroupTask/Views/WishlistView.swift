//
//  WishlistView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var authManager: AuthManagerViewModel
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var showLoginView = false

    var body: some View {
        NavigationStack {
            if authManager.isAuthenticated {
                authenticatedWishListView
            } else {
                NotLoginView(
                    screen: "Log in to view your Wishlists",
                    tittle:
                        "You can create, view, or edit Wishlists once you've logged in."
                )
                .navigationTitle("Wishlists")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginSignUpView()
        }
        .onAppear {
            if authManager.isAuthenticated {
                cloudkitViewModel.fetchUserWishlist()
            }
        }
    }

    private var authenticatedWishListView: some View {
        VStack(alignment: .leading) {
            if cloudkitViewModel.isLoading && cloudkitViewModel.wishlistedProperties.isEmpty {
                ProgressView("Loading wishlist...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if cloudkitViewModel.wishlistedProperties.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No items in your wishlist")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Start exploring properties and save your favorites here")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(cloudkitViewModel.wishlistedProperties) { property in
                            NavigationLink {
                                PropertyDetailView(property: property)
                            } label: {
                                PropertyListItemView(property: property)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Wishlists")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            cloudkitViewModel.fetchUserWishlist(forceRefresh: true)
        }
    }
}

#Preview {
    WishlistView()
        .environmentObject(AuthManagerViewModel())
        .environmentObject(CloudkitManagerViewModel())
}
