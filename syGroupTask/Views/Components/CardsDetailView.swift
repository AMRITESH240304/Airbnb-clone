//
//  CardsDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct CardsDetailView: View {
    @State var number: UUID?

    var body: some View {
        VStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Example Image
                    Image("house1") // Replace with dynamic image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 280)
                        .clipped()

                    // Title + Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Manash's Retreat! A family friendly place.")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Entire rental unit in Puducherry, India\n5 guests · 2 bedrooms · 2 beds · 2 bathrooms")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.horizontal)

                    Divider()

                    // Ratings + Guest Favourite + Reviews
                    HStack {
                        VStack {
                            Text("4.75")
                                .fontWeight(.bold)
                            Text("★★★★★")
                                .font(.caption)
                        }
                        Spacer()
                        VStack {
                            Text("Guest")
                                .fontWeight(.bold)
                            Text("favourite")
                                .font(.caption)
                        }
                        Spacer()
                        VStack {
                            Text("16")
                                .fontWeight(.bold)
                            Text("Reviews")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal)

                    Divider()

                    // Host Info
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Theme.textSecondary)
                        VStack(alignment: .leading) {
                            Text("Hosted by Nirav Kumar")
                                .fontWeight(.bold)
                            Text("7 years hosting")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(.horizontal)

                    // Placeholder for more content
                    ForEach(0..<10) { _ in
                        Text("Some more details here...")
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
            }

            // Sticky Button
            VStack {
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Add dates for prices")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Text("⭐️ 4.75")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Button(action: {
                        print("Check availability tapped")
                    }) {
                        Text("Check availability")
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textLight)
                            .padding()
                            .frame(width: 180)
                            .background(Theme.primaryColor)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Theme.background)
            }
        }
        .ignoresSafeArea(edges: .bottom) // so button sticks at bottom
    }
}

#Preview {
    CardsDetailView()
}
