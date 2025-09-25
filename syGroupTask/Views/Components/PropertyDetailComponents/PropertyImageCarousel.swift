//
//  PropertyImageCarousel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct PropertyImageCarousel: View {
    let photoURLs: [String]
    
    var body: some View {
        if !photoURLs.isEmpty {
            TabView {
                ForEach(photoURLs, id: \.self) { imageURL in
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            )
                    }
                    .frame(height: 280)
                    .clipped()
                }
            }
            .frame(height: 280)
            .tabViewStyle(PageTabViewStyle())
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 280)
                .overlay(
                    Image(systemName: "house")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                )
        }
    }
}

