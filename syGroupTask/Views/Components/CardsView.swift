//
//  CardsView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct CardsView: View {
    var flatName: String
    var cost: String
    var rating: Double
    var label: String
    var imageName: String
    var imageURL: String?
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topLeading) {
                // Background image - use URL if available, fallback to local image
                if let imageURL = imageURL {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .frame(width: 280, height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 280, height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Top row: Label + Heart
                HStack {
                    Text(label)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.textLight.opacity(0.9))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? Theme.primaryColor : Theme.textLight)
                            .font(.system(size: 20))
                    }
                }
                .padding(8)
            }
            
            // Flat name
            Text(flatName)
                .font(.headline)
                .lineLimit(1)
                .foregroundStyle(Theme.textSecondary)
            
            // Cost + Rating
            HStack {
                Text(cost)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.star)
                        .font(.caption)
                    Text(String(format: "%.2f", rating))
                        .font(.subheadline)
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .padding(8)
    }
}

#Preview {
    CardsView(
        flatName: "Flat in Puducherry",
        cost: "₹3,251 for 2 nights",
        rating: 4.83,
        label: "Guest favourite",
        imageName: "sample_room",
        imageURL: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c"
    )
    .previewLayout(.sizeThatFits)
    .padding()
}

