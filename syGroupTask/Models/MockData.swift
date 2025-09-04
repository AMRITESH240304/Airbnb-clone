//
//  MockData.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import Foundation

import Foundation

struct CardModel: Identifiable {
    let id = UUID()
    let flatName: String
    let cost: String
    let rating: Double
    let label: String
    let imageName: String
    var isLiked: Bool = false
}


struct MockData {
    static let sampleCards: [CardModel] = [
        CardModel(flatName: "Flat in Puducherry",
                  cost: "₹3,251 for 2 nights",
                  rating: 4.83,
                  label: "Guest favourite",
                  imageName: "sample_room"),
        
        CardModel(flatName: "Villa in Goa",
                  cost: "₹6,500 for 3 nights",
                  rating: 4.95,
                  label: "Top rated",
                  imageName: "sample_villa"),
        
        CardModel(flatName: "Cabin in Manali",
                  cost: "₹4,200 for 2 nights",
                  rating: 4.76,
                  label: "Mountain view",
                  imageName: "sample_cabin")
    ]
}
