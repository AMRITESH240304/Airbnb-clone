//
//  SwiftUIView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct CollaborationCard: View {
    let collaboration: Collaboration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: collaboration.logoImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "building.2")
                            .foregroundColor(.gray)
                            .font(.title2)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(collaboration.businessName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                
                Text(collaboration.businessType.rawValue)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(Theme.primaryColor)
                        .font(.caption)
                    Text(collaboration.location)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                }
                
                Text(collaboration.investmentRange.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.primaryColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.primaryColor.opacity(0.1))
                    .cornerRadius(8)
                
                HStack {
                    if collaboration.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                    if collaboration.isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", collaboration.rating))
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
        .padding()
        .frame(width: 220)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
