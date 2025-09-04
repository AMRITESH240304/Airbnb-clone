//
//  SearchResultCard.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 04/09/25.
//

import SwiftUI

struct SearchResultCard: View {
    let card: CardModel
    @State private var isLiked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Image with heart button and label
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    // Use AsyncImage if imageURL is available
                    if let imageURL = card.imageURL {
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                )
                        }
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Image(card.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Label
                    Text(card.label)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Theme.textLight.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(6)
                }
                
                Button {
                    isLiked.toggle()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isLiked ? Theme.primaryColor : Theme.textLight)
                        .frame(width: 24, height: 24)
                        .background(Theme.textPrimary.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(6)
            }
            
            // Property Details
            VStack(alignment: .leading, spacing: 3) {
                Text(card.flatName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                
                Text(card.location)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
                
                Text(card.cost)
                    .font(.system(size: 11))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Theme.star)
                    
                    Text(String(format: "%.1f", card.rating))
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textPrimary)
                }
            }
            .padding(.horizontal, 4)
        }
    }
}
