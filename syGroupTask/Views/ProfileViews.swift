//
//  ProfileViews.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct ProfileViews: View {
    var body: some View {
        NavigationStack {
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
                        
                        Text("Guest")
                            .foregroundColor(Theme.textSecondary)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    HStack(spacing: 16) {
                        ProfileOptionCard(
                            image: "bag",
                            title: "Past trips",
                            badge: true
                        )
                        
                        ProfileOptionCard(
                            image: "people",
                            title: "Connections",
                            badge: true
                        )
                    }
                    
                    ProfileOptionCard(
                        image: "singlePerson",
                        title: "Become a host",
                        subtitle: "It’s easy to start hosting and earn extra income."
                    )
                    
                    VStack(spacing: 20) {
                        Divider().padding(.top, 10)
                        
                            Section {
                                ProfileListItem(icon: "gearshape.fill", title: "Account settings", showBadge: true)
                                ProfileListItem(icon: "questionmark.circle", title: "Get help")
                                ProfileListItem(icon: "person", title: "View profile")
                                ProfileListItem(icon: "hand.raised", title: "Privacy")
                            }
                            
                            Section {
                                ProfileListItem(icon: "person.2", title: "Refer a host")
                                ProfileListItem(icon: "person.crop.circle.badge.plus", title: "Find a co-host")
                                ProfileListItem(icon: "book.closed", title: "Legal")
                                ProfileListItem(icon: "rectangle.portrait.and.arrow.right", title: "Log out")
                            }
                        
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
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

#Preview{
    ProfileViews()
}
