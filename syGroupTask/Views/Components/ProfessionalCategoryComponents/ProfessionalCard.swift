//
//  ProfessionalCard.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct ProfessionalCard: View {
    let professional: Professional
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: professional.profileImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Theme.primaryColor.opacity(0.2))
                    .overlay(
                        Text(String(professional.businessName.prefix(1)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.blue)
                    .offset(x: 20, y: 20)
            )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(professional.businessName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(professional.location)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", professional.rating))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Text("(\(professional.reviewCount))")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                }
                
                Text("₹\(Int(professional.services.first?.price ?? 0))+")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryColor)
            }
        }
        .padding()
        .frame(width: 200)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
