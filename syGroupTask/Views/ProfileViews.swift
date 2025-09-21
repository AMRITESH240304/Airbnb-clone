//
//  ProfileViews.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI
import Charts

struct ProfileViews: View {
    @EnvironmentObject var authViewModel: AuthManagerViewModel
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var showLoginView = false
    @State private var showIncomeSheet = false
    @State private var showTransactionSheet = false
    @State private var showProfessionalRegistration = false
    
    var body: some View {
        NavigationStack {
            if authViewModel.isAuthenticated {
                authenticatedProfileView
            } else {
                guestProfileView
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginSignUpView()
        }
        .sheet(isPresented: $showIncomeSheet) {
            IncomeAnalyticsView()
                .environmentObject(cloudkitViewModel)
        }
        .sheet(isPresented: $showTransactionSheet) {
            TransactionHistoryView()
                .environmentObject(cloudkitViewModel)
        }
        .sheet(isPresented: $showProfessionalRegistration) {
            ProfessionalRegistrationView()
                .environmentObject(cloudkitViewModel)
        }
    }
    
    private var guestProfileView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
                .padding(.top, 16)
                .padding(.bottom, 4)
            
            Text("Log in and start planning your next trip.")
                .font(.headline)
                .foregroundColor(Theme.textSecondary)
                .padding(.bottom, 16)
            
            Button(action: {
                authViewModel.exitGuestMode()
                showLoginView = true
            }) {
                Text("Log in or sign up")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textLight)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(8)
            }
            .padding(.bottom, 24)
            
            Divider()
                .padding(.vertical, 8)
            
            // Settings row
            Button(action: {
                // Account settings action
            }) {
                HStack {
                    Image(systemName: "gearshape")
                        .font(.system(size: 22))
                        .foregroundColor(Theme.textPrimary)
                        .frame(width: 32)
                    
                    Text("Account settings")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.vertical, 12)
            }
            
            Divider()
            
            // Get help row
            Button(action: {
                // Get help action
            }) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 22))
                        .foregroundColor(Theme.textPrimary)
                        .frame(width: 32)
                    
                    Text("Get help")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.vertical, 12)
            }
            
            Divider()
            
            // Legal row
            Button(action: {
                // Legal action
            }) {
                HStack {
                    Image(systemName: "book.closed")
                        .font(.system(size: 22))
                        .foregroundColor(Theme.textPrimary)
                        .frame(width: 32)
                    
                    Text("Legal")
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.vertical, 12)
            }
            
            Divider()
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var authenticatedProfileView: some View {
        ScrollView {
            VStack {
                VStack(spacing: 10) {
                    Circle()
                        .fill(Theme.textPrimary)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("A")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(Theme.textLight)
                        )
                    
                    Text("Amritesh")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Property Owner")
                        .foregroundColor(Theme.textSecondary)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                HStack(spacing: 16) {
                    if !cloudkitViewModel.isUserProfessional() {
                        Button(action: {
                            showProfessionalRegistration = true
                        }) {
                            ProfileOptionCard(
                                image: "bag",
                                title: "Become a Professional",
                                badge: true
                            )
                        }
                    } else {
                        ProfileOptionCard(
                            image: "bag",
                            title: "Professional Account",
                            subtitle: "Active"
                        )
                    }
                    
                    ProfileOptionCard(
                        image: "people",
                        title: "Business Collaboration / Franchise",
                        badge: true
                    )
                }
                
                VStack(spacing: 20) {
                    Divider().padding(.top, 10)
                    
                    Section {
                        Button(action: {
                            showIncomeSheet = true
                        }) {
                            ProfileListItem(icon: "chart.bar.fill", title: "Income Analytics", showBadge: false)
                        }
                        
                        Button(action: {
                            showTransactionSheet = true
                        }) {
                            ProfileListItem(icon: "list.bullet.rectangle", title: "Transaction History", showBadge: false)
                        }
                        
                        ProfileListItem(icon: "gearshape.fill", title: "Account settings", showBadge: true)
                        ProfileListItem(icon: "questionmark.circle", title: "Get help")
                        ProfileListItem(icon: "person", title: "View profile")
                        ProfileListItem(icon: "hand.raised", title: "Privacy")
                    }
                    
                    Section {
                        ProfileListItem(icon: "person.2", title: "Refer a host")
                        ProfileListItem(icon: "person.crop.circle.badge.plus", title: "Find a co-host")
                        ProfileListItem(icon: "book.closed", title: "Legal")
                        
                        Button(action: {
                            authViewModel.removeUser()
                        }) {
                            ProfileListItem(icon: "rectangle.portrait.and.arrow.right", title: "Log out")
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            cloudkitViewModel.fetchUserPayments(forceRefresh: true)
            cloudkitViewModel.fetchUserRevenue()
            cloudkitViewModel.fetchAllProfessionals()
        }
    }
}

// MARK: - Reusable Option Card
struct ProfileOptionCard: View {
    var image: String
    var title: String
    var subtitle: String? = nil
    var badge: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top, 10)
                
                if badge {
                    Text("NEW")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(4)
                        .background(Color.blue)
                        .foregroundColor(Theme.textLight)
                        .cornerRadius(6)
                        .offset(x: 10, y: -10)
                }
            }
            
            Text(title)
                .font(.headline)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct ProfileListItem: View {
    var icon: String
    var title: String
    var showBadge: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.textPrimary)
            Text(title)
                .fontWeight(.medium)
            
            Spacer()
            
            if showBadge {
                Circle()
                    .fill(Color.pink)
                    .frame(width: 8, height: 8)
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProfileViews()
        .environmentObject(AuthManagerViewModel())
}
