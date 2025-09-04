//
//  CardsView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct CardsView: View {
    var flatName: String
    var location: String
    var cost: String
    var rating: Double
    var label: String
    var imageName: String
    var imageURL: String?
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topLeading) {
                if let imageURL = imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 60, height: 60)

                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)

                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)

                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Top row: Label + Heart
                HStack {
                    Text(label)
                        .font(.system(size: 10, weight: .medium)) // Smaller font
                        .foregroundColor(Theme.textPrimary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Theme.textLight.opacity(0.9))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? Theme.primaryColor : Theme.textLight)
                            .font(.system(size: 16)) // Smaller heart
                    }
                }
                .padding(6)
            }
            
            // Flat name
            Text(flatName)
                .font(.system(size: 14, weight: .medium)) // Smaller font
                .lineLimit(2)
                .foregroundStyle(Theme.textPrimary)
            
            // Location
            Text(location)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineLimit(1)
            
            // Cost + Rating
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(cost)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.star)
                        .font(.system(size: 10))
                    Text(String(format: "%.1f", rating))
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .frame(width: 180) // Set fixed width
        .padding(4)
    }
}

#Preview {
    CardsView(
        flatName: "Flat in Puducherry",
        location: "White Town, Puducherry",
        cost: "₹3,251 for 2 nights",
        rating: 4.83,
        label: "Guest favourite",
        imageName: "sample_room",
        imageURL: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c"
    )
    .previewLayout(.sizeThatFits)
    .padding()
}

