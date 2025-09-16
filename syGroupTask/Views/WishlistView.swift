//
//  WishlistView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var authManager: AuthManagerViewModel
    let images = ["sample1", "sample2", "sample3", "sample4"]
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
    }

    private var authenticatedWishListView: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: 0),
                        count: 2
                    ),
                    spacing: 0
                ) {
                    ForEach(MockData.imageURLs, id: \.self) { urlString in
                        if let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipped()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                .frame(width: 160, height: 160)
                .cornerRadius(12)

                Text("Recently viewed")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)

                Text("Today")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
            }

            Spacer()
        }
        .navigationTitle("Wishlists")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    WishlistView()
        .environmentObject(AuthManagerViewModel())
}
