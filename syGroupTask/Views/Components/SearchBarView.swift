//
//  SearchBarView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.textPrimary)
            
            Text("Where are you going?")
                .font(.system(size: 16))
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Theme.background)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
        .shadow(color: Theme.textPrimary.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
