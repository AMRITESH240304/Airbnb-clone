//
//  PropertyPriceSection.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct PropertyPriceSection: View {
    let property: PropertyListing
    let viewModel: PropertyDetailViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("₹\(Int(property.price))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                
                Text(property.listingType.rawValue)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(property.status.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(viewModel.getStatusColor(property.status))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(viewModel.getStatusColor(property.status).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("Category: \(property.category)")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(.horizontal)
    }
}
