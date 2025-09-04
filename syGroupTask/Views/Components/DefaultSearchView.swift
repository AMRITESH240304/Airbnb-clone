//
//  DefaultSearchView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 04/09/25.
//

import SwiftUI

struct DefaultSearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                SearchFieldSection(viewModel: viewModel)
                RecentSearchesSection(viewModel: viewModel)
                SuggestedDestinationsSection(viewModel: viewModel)
                Spacer()
            }
            .padding(20)
            .background(Theme.background)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            Spacer()
            
            DateAndGuestSection()
            Spacer()
            SearchFooterSection(viewModel: viewModel)
        }
    }
}
