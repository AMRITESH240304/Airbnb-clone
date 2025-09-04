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
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topLeading) {
                // Background image
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
                // Top row: Label + Heart
                HStack {
                    Text(label)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .cornerRadius(10)
                        .foregroundStyle(Theme.textSecondary)
                    
                    Spacer()
                    
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .black)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .onTapGesture {
                            isLiked.toggle()
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
                    .foregroundStyle(Theme.textSecondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.2f", rating))
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
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
        imageName: "sample_room" // Add your image in Assets
    )
    .previewLayout(.sizeThatFits)
    .padding()
}

