//
//  WishlistView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct WishlistView: View {
    let images = ["sample1", "sample2", "sample3", "sample4"]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 8) {
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 0) {
                    ForEach(images, id: \.self) { image in
                        Image(systemName: "heart")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipped()
                    }
                }
                .frame(width: 160, height: 160)
                .cornerRadius(12)
                
                Text("Recently viewed")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Today")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .navigationTitle("Wishlists")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    WishlistView()
}
