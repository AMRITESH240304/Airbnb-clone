//
//  PropertyListItemView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 19/09/25.
//

import SwiftUI

struct PropertyListItemView: View {
    let property: PropertyListing
    
    var body: some View {
        HStack(spacing: 12) {
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
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(property.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                
                Text(property.location)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
                
                Text(property.description)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Text("$\(Int(property.price))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(property.listingType.rawValue)
                            .font(.system(size: 10, weight: .medium))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Theme.textSecondary.opacity(0.1))
                            .foregroundColor(Theme.textSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        
                        Text(property.status.rawValue)
                            .font(.system(size: 10))
                            .foregroundColor(property.status == .active ? .green : .orange)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

