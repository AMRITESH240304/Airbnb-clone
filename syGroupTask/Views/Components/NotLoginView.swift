//
//  NotLoginView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 16/09/25.
//

import SwiftUI

struct NotLoginView: View {
    let screen: String
    let tittle: String
    @State private var showLoginView = false
    @EnvironmentObject var authViewModel: AuthManagerViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(screen)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                
                Text(tittle)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
            }
            .padding(.bottom, 16)
            
            Button(action: {
                authViewModel.exitGuestMode()
                showLoginView = true
            }) {
                Text("Log in")
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textLight)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Theme.primaryColor)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fullScreenCover(isPresented: $showLoginView) {
            LoginSignUpView()
        }
    }
}

#Preview {
    NotLoginView(screen: "Log in to view your Wishlists", tittle: "You can create, view, or edit Wishlists once you've logged in.")
        .environmentObject(AuthManagerViewModel())
}
