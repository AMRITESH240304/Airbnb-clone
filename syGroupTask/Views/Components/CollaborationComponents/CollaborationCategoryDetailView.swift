//
//  CollaborationCategoryDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct CollaborationCategoryDetailView: View {
    let categoryName: String
    let collaborations: [Collaboration]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(collaborations) { collaboration in
                    NavigationLink(destination: CollaborationDetailView(collaboration: collaboration)) {
                        CollaborationListCard(collaboration: collaboration)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
    }
}
