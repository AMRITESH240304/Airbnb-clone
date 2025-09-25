//
//  PropertyOwnerSection.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct PropertyOwnerSection: View {
    let property: PropertyListing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Listed by")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
            
            HStack {
                Circle()
                    .fill(Theme.primaryColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(property.ownerName.prefix(1)).uppercased())
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(property.ownerName)
                        .font(.headline)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("Property Owner")
                        .font(.subheadline)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

