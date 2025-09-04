//
//  TripsView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct TripsView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Trips")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            VStack(spacing: 32) {
                Image("tripTimeline")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 280, maxHeight: 280)
                
                VStack(spacing: 16) {
                    Text("Build the perfect trip")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Explore homes, experiences and services.\nWhen you book, your reservations will appear here.")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    
                }) {
                    Text("Get started")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.pink)
                        )
                }
                .padding(.horizontal, 60)
            }
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    TripsView()
}
