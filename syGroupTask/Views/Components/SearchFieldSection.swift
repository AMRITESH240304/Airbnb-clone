//
//  SearchFieldSection.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 04/09/25.
//

import SwiftUI

struct SearchFieldSection: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Where?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                Spacer()
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.textSecondary)
                    .font(.system(size: 18))
                TextField("Search destinations", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 16))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
        }
    }
}
