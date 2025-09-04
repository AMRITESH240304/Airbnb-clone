//
//  CardsDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct CardsDetailView: View {
    let cardId: UUID
    @State private var propertyDetail: PropertyDetail
    
    init(cardId: UUID) {
        self.cardId = cardId
        self._propertyDetail = State(initialValue: MockData.getPropertyDetailOrDefault(for: cardId))
    }

    var body: some View {
        VStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Dynamic Image Carousel
                    TabView {
                        ForEach(propertyDetail.images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 280)
                                .clipped()
                        }
                    }
                    .frame(height: 280)
                    .tabViewStyle(PageTabViewStyle())

                    // Title + Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text(propertyDetail.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)

                        Text("\(propertyDetail.subtitle) in \(propertyDetail.location)\n\(propertyDetail.maxGuests) guests · \(propertyDetail.bedrooms) bedrooms · \(propertyDetail.bedrooms) beds · \(propertyDetail.bathrooms) bathrooms")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    .padding(.horizontal)

                    Divider()

                    // Ratings + Guest Favourite + Reviews
                    HStack {
                        VStack {
                            Text(String(format: "%.2f", propertyDetail.rating))
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: "star.fill")
                                        .font(.caption)
                                        .foregroundColor(index < Int(propertyDetail.rating) ? Theme.star : Theme.textSecondary)
                                }
                            }
                        }
                        Spacer()
                        if propertyDetail.isGuestFavourite {
                            VStack {
                                Text("Guest")
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.textPrimary)
                                Text("favourite")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer()
                        }
                        VStack {
                            Text("\(propertyDetail.reviewCount)")
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            Text("Reviews")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .padding(.horizontal)

                    Divider()

                    // Host Info
                    HStack {
                        Image(propertyDetail.host.profileImage)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(lineWidth: 1))
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Hosted by \(propertyDetail.host.name)")
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.textPrimary)
                                if propertyDetail.host.isSuperhost {
                                    Text("★ Superhost")
                                        .font(.caption)
                                        .foregroundColor(Theme.star)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Theme.star.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                            Text("\(propertyDetail.host.hostingSince) years hosting")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)

                    Divider()

                    // Amenities Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What this place offers")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(propertyDetail.amenities, id: \.self) { amenity in
                                HStack {
                                    Image(systemName: getAmenityIcon(amenity))
                                        .foregroundColor(Theme.textSecondary)
                                        .frame(width: 20)
                                    Text(amenity)
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textPrimary)
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Divider()

                    // Description Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About this place")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)
                        
                        Text(propertyDetail.description)
                            .font(.body)
                            .foregroundColor(Theme.textSecondary)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)

                    Divider()

                    // Host Details Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Meet your host")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Response rate:")
                                    .foregroundColor(Theme.textSecondary)
                                Spacer()
                                Text(propertyDetail.host.responseRate)
                                    .fontWeight(.medium)
                                    .foregroundColor(Theme.textPrimary)
                            }
                            
                            HStack {
                                Text("Response time:")
                                    .foregroundColor(Theme.textSecondary)
                                Spacer()
                                Text(propertyDetail.host.responseTime)
                                    .fontWeight(.medium)
                                    .foregroundColor(Theme.textPrimary)
                            }
                        }
                        .padding()
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Add some bottom padding
                    Spacer()
                        .frame(height: 100)
                }
                .padding(.vertical, 8)
            }

            // Sticky Button
            VStack {
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(propertyDetail.currency)\(propertyDetail.pricePerNight) night")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)
                        HStack {
                            Text("⭐️ \(String(format: "%.2f", propertyDetail.rating))")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                            Text("·")
                                .foregroundColor(Theme.textSecondary)
                            Text("\(propertyDetail.checkIn) - \(propertyDetail.checkOut)")
                                .font(.caption)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    Spacer()
                    Button(action: {
                        print("Check availability tapped for \(propertyDetail.title)")
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
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
    }
    
    // Helper function to get appropriate SF Symbol for amenities
    private func getAmenityIcon(_ amenity: String) -> String {
        switch amenity.lowercased() {
        case "wifi": return "wifi"
        case "kitchen": return "fork.knife"
        case "air conditioning": return "snow"
        case "pool": return "figure.pool.swim"
        case "free parking", "parking": return "car.fill"
        case "tv": return "tv.fill"
        case "washer": return "washinmachine.fill"
        case "iron": return "iron.fill"
        case "beach access": return "beach.umbrella.fill"
        case "hot tub": return "bathtub.fill"
        case "bbq grill": return "flame.fill"
        case "mountain view": return "mountain.2.fill"
        case "fireplace": return "flame.fill"
        case "heating": return "thermometer.sun.fill"
        case "garden": return "leaf.fill"
        case "hiking trails": return "figure.hiking"
        case "shared kitchen": return "fork.knife"
        case "meditation space": return "leaf.fill"
        case "bicycle": return "bicycle"
        case "breakfast": return "cup.and.saucer.fill"
        case "terrace": return "building.2.fill"
        default: return "checkmark.circle.fill"
        }
    }
}

#Preview {
    NavigationView {
        CardsDetailView(cardId: UUID())
    }
}
