//
//  PropertyListItemView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct PropertyListItemView: View {
    let property: PropertyListing
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Property Image
            PropertyImageView(property: property)
            
            // Property Details
            PropertyDetailsView(property: property)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct PropertyImageView: View {
    let property: PropertyListing
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Property Image
            if let firstImageURL = property.photoURLs.first, !firstImageURL.isEmpty {
                AsyncImage(url: URL(string: firstImageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        )
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "house.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
            }
            
            // Wishlist Heart Button
            Button {
                toggleWishlist()
            } label: {
                Image(systemName: cloudkitViewModel.isPropertyInWishlist(property) ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundColor(cloudkitViewModel.isPropertyInWishlist(property) ? .red : .white)
                    .padding(8)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.3))
                    )
            }
            .padding(12)
        }
        .frame(height: 200)
        .clipped()
    }
    
    private func toggleWishlist() {
        if cloudkitViewModel.isPropertyInWishlist(property) {
            cloudkitViewModel.removeFromWishlist(property: property) { result in
                // Handle result if needed
            }
        } else {
            cloudkitViewModel.addToWishlist(property: property) { result in
                // Handle result if needed
            }
        }
    }
}

struct PropertyDetailsView: View {
    let property: PropertyListing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Property Title and Location
            VStack(alignment: .leading, spacing: 4) {
                Text(property.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                
                Text(property.location)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
            }
            
            // Property Category and Type
            HStack {
                PropertyBadge(text: property.category, color: .blue)
                PropertyBadge(text: property.listingType.rawValue, color: property.listingType == .forSale ? .green : .orange)
                
                Spacer()
                
                // Property Status - Updated to use ListingStatus
                ListingStatusBadge(status: property.status)
            }
            
            // Price and Contact Count
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("₹\(formatPrice(property.price))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    if property.listingType == .forRent {
                        Text("per month")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                Spacer()
                
                // Contact count and listing date
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                        Text("\(property.contactCount)")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Text(formatRelativeDate(property.listingDate))
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            // Property Description Preview
            Text(property.description)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
    }
    
    private func formatPrice(_ price: Double) -> String {
        if price >= 10000000 { // 1 crore
            return String(format: "%.1fCr", price / 10000000)
        } else if price >= 100000 { // 1 lakh
            return String(format: "%.1fL", price / 100000)
        } else if price >= 1000 { // 1 thousand
            return String(format: "%.1fK", price / 1000)
        } else {
            return String(format: "%.0f", price)
        }
    }
    
    private func formatRelativeDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Check if it's today
        if calendar.dateInterval(of: .day, for: now)?.contains(date) == true {
            return "Today"
        }
        
        // Check if it's yesterday
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
           calendar.dateInterval(of: .day, for: yesterday)?.contains(date) == true {
            return "Yesterday"
        }
        
        // Calculate days ago
        let days = calendar.dateComponents([.day], from: date, to: now).day ?? 0
        if days < 7 {
            return "\(days) days ago"
        } else if days < 30 {
            let weeks = days / 7
            return "\(weeks) week\(weeks > 1 ? "s" : "") ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }
}

struct PropertyBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1))
            .cornerRadius(6)
    }
}

// Updated to use ListingStatus instead of PropertyStatus
struct ListingStatusBadge: View {
    let status: ListingStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.1))
            .cornerRadius(6)
    }
    
    private var statusColor: Color {
        switch status {
        case .active:
            return .green
        case .pending:
            return .orange
        case .sold:
            return .red
        case .expired:
            return .gray
        }
    }
}

// Remove the PropertyStatus enum since we're using ListingStatus

#Preview {
    PropertyListItemView(property: PropertyListing(
        id: UUID(),
        recordID: nil,
        title: "Beautiful 2BHK Apartment",
        category: "Apartment",
        location: "Puducherry, India",
        description: "A beautiful 2BHK apartment with modern amenities and great location. Perfect for families looking for a comfortable stay.",
        listingType: .forRent,
        price: 25000,
        listingDuration: 30,
        listingDate: Date(),
        expirationDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        status: .active,
        ownerID: "test-owner",
        ownerName: "John Doe",
        photoURLs: [],
        bids: [],
        highestBid: nil,
        listingTier: .basic,
        isPremium: false,
        isFeatured: false,
        contactCount: 12
    ))
    .environmentObject(CloudkitManagerViewModel())
    .padding()
}
