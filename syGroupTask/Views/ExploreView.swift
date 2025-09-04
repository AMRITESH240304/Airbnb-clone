//
//  ExploreView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct ExploreView: View {

    @State private var searchText = ""
    @State private var isSearching = false

    var body: some View {
        ZStack {
            Theme.background
            VStack(spacing: 20) {

                Button {
                    isSearching = true
                } label: {
                    SearchBarView(searchText: $searchText)
                }
                .fullScreenCover(isPresented: $isSearching) {
                    SearchView(
                        isSearching: $isSearching,
                        searchText: $searchText
                    )
                }

                NavigationLink {
                    // Destination View
                } label: {
                    HStack {
                        Text("Recently View homes")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .fixedSize()
                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                }
                ScrollView(.horizontal) {

                    HStack {
                        ForEach(MockData.sampleCards) { card in
                            NavigationLink {
                                CardsDetailView(number: card.id)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                CardsView(
                                    flatName: card.flatName,
                                    cost: card.cost,
                                    rating: card.rating,
                                    label: card.label,
                                    imageName: card.imageName
                                )
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ExploreView()
}
