//
//  CardsView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct CardsView: View {
    var flatName: String
    var location: String
    var cost: String
    var rating: Double
    var label: String
    var imageName: String
    var imageURL: String?
    @State private var isLiked = false
    @State private var cachedImage: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topLeading) {
                if let imageURL = imageURL {
                    Group {
                        if let cachedImage = cachedImage {
                            Image(uiImage: cachedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if isLoading {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onAppear {
                        loadImage(from: imageURL)
                    }
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                HStack {
                    Text(label)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Theme.textLight.opacity(0.9))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? Theme.primaryColor : Theme.textLight)
                            .font(.system(size: 16))
                    }
                }
                .padding(6)
            }
            
            Text(flatName)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(2)
                .foregroundStyle(Theme.textPrimary)
            
            Text(location)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineLimit(1)
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(cost)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.star)
                        .font(.system(size: 10))
                    Text(String(format: "%.1f", rating))
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
        .frame(width: 180) 
        .padding(4)
    }
    
    private func loadImage(from urlString: String) {
        isLoading = true
        
        Task {
            let image = await ImageCacheManager.shared.getImage(from: urlString)
            await MainActor.run {
                self.cachedImage = image
                self.isLoading = false
            }
        }
    }
}

