//
//  PropertyDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 19/09/25.
//

import SwiftUI

struct PropertyDetailView: View {
    let property: PropertyListing
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(property.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(property.location)
                    .font(.title2)
                    .foregroundColor(Theme.textSecondary)
                
                Text(property.description)
                    .font(.body)
                
                Text("Price: ₹\(Int(property.price))")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Type: \(property.listingType.rawValue)")
                    .font(.body)
                
                Text("Status: \(property.status.rawValue)")
                    .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Property Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

