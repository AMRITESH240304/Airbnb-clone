//
//  TripsView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct TripsView: View {
    @EnvironmentObject var authManager: AuthManagerViewModel
    @StateObject private var cloudKitManager = CloudkitManagerViewModel()
    @State private var showLoginView = false
    @State private var showAddPropertySheet = false

    @State private var wasNewPropertyAdded = false

    var body: some View {
        NavigationStack {
            if authManager.isAuthenticated {
                myPropertiesView
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("My Properties")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showAddPropertySheet = true
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Theme.primaryColor)
                            }
                        }
                    }
                    .sheet(isPresented: $showAddPropertySheet) {
                        AddPropertyView(wasListingAdded: $wasNewPropertyAdded)
                            .presentationDetents([.large])
                            .onDisappear {
                                // Only refresh if a property was successfully added
                                if wasNewPropertyAdded {
                                    cloudKitManager.fetchUserListings(forceRefresh: true)
                                    wasNewPropertyAdded = false
                                }
                            }
                    }
                    .onAppear {
                        cloudKitManager.fetchUserListings()
                    }
            } else {
                NotLoginView(
                    screen: "My Properties",
                    tittle:
                        "Sign in to list your properties and connect with potential buyers"
                )
                .navigationTitle("My Properties")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Login") {
                            showLoginView = true
                        }
                        .foregroundColor(Theme.primaryColor)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginSignUpView()
        }
    }

    private var myPropertiesView: some View {
        ScrollView {
            if cloudKitManager.isLoading {
                VStack {
                    Spacer()
                        .frame(height: 100)
                    ProgressView("Loading properties...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else if cloudKitManager.userProperties.isEmpty {
                emptyStateView
            } else {
                VStack(alignment: .leading) {
                    LazyVStack(spacing: 16) { // Changed from LazyVGrid to LazyVStack
                        ForEach(cloudKitManager.userProperties) { property in
                            NavigationLink(
                                destination: PropertyDetailView(property: property)
                            ) {
                                propertyCard(for: property)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }

            if let errorMessage = cloudKitManager.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .background(Theme.background)
        .refreshable {
            cloudKitManager.fetchUserListings(forceRefresh: true)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 80)

            Image(systemName: "house")
                .font(.system(size: 64))
                .foregroundColor(Color(.systemGray3))

            Text("No Properties Listed")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)

            Text("Tap the + button to list your first property")
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                showAddPropertySheet = true
            } label: {
                Text("List a Property")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Theme.primaryColor)
                    )
            }
            .padding(.top, 12)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func propertyCard(for property: PropertyListing) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Reuse PropertyImageCarousel from PropertyDetailView
            PropertyImageCarousel(photoURLs: property.photoURLs)
                .frame(height: 120) // Adjust height to fit the grid
                .clipShape(RoundedRectangle(cornerRadius: 8)) // Smaller corner radius for compact design

            // Reuse PropertyHeaderSection
            PropertyHeaderSection(property: property)
                .padding(.horizontal, 4) // Reduce padding for compact layout

            // Reuse PropertyPriceSection
            PropertyPriceSection(property: property, viewModel: PropertyDetailViewModel(cardId: property.id, property: property))
                .padding(.horizontal, 4) // Reduce padding for compact layout
        }
        .padding(8) // Reduce overall padding
        .background(Color(.systemGray6))
        .cornerRadius(12) // Adjust corner radius for compact design
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    TripsView()
        .environmentObject(AuthManagerViewModel())
}
