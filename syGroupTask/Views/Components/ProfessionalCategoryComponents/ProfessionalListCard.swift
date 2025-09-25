//
//  ProfessionalListCard.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct ProfessionalListCard: View {
    let professional: Professional
    
    var body: some View {
        HStack(spacing: 16) {
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
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(professional.businessName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.blue)
                }
                
                Text(professional.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(Theme.textSecondary)
                        .font(.caption)
                    
                    Text(professional.location)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", professional.rating))
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text("(\(professional.reviewCount))")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                HStack {
                    Text("\(professional.experience) years experience")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.primaryColor.opacity(0.1))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Text("From ₹\(Int(professional.services.min(by: { $0.price < $1.price })?.price ?? 0))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryColor)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

