//
//  CategorySectionView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 19/09/25.
//

import SwiftUI

struct CategorySectionView: View {
    let categoryName: String
    let properties: [PropertyListing]
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink {
                CategoryDetailView(
                    categoryName: categoryName,
                    properties: properties
                )
                .toolbar(.hidden, for: .tabBar)
            } label: {
                HStack {
                    Text(categoryName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.horizontal)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(properties.prefix(10)) { property in // Limit to 10 items for performance
                        NavigationLink {
                            PropertyDetailView(property: property)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            PropertyCardView(property: property)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Property Card Component
struct PropertyCardView: View {
    let property: PropertyListing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Property Image
            AsyncImage(url: URL(string: property.photoURLs.first ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "house")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 240, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(property.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                
                Text(property.location)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
                
                HStack {
                    Text("₹\(Int(property.price))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Text(property.listingType.rawValue)
                        .font(.system(size: 10, weight: .medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Theme.textSecondary.opacity(0.1))
                        .foregroundColor(Theme.textSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(width: 240)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
