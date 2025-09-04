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
                .foregroundColor(.gray)
            
            TextField("Start your search", text: $searchText)
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .regular))
            
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
        )
        .padding(.horizontal)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
