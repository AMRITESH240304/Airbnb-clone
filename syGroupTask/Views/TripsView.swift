//
//  TripsView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct TripsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            Text("Trips")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Theme.textPrimary)
                .padding(.horizontal, 20)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("Build the perfect trip")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                
                Text("Explore homes, experiences and services.\nWhen you book, your reservations will appear here.")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    
                }) {
                    Text("Get started")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Theme.textLight)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [Theme.primaryColor, Theme.warning],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.top, 12)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    TripsView()
}
