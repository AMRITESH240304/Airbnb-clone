//
//  PropertyDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 19/09/25.
//

import SwiftUI
import MapKit

struct PropertyDetailView: View {
    let property: PropertyListing
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var isWishlisted: Bool = false
    @State private var region = MKCoordinateRegion()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                }
                .padding(.leading)
                
                Spacer()
                
                Button {
                    toggleWishlist()
                } label: {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isWishlisted ? .red : Theme.textPrimary)
                }
                .padding(.trailing)
            }
            .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if !property.photoURLs.isEmpty {
                        TabView {
                            ForEach(property.photoURLs, id: \.self) { imageURL in
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
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(property.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text(property.location)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("₹\(Int(property.price))")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.textPrimary)
                                
                                Text(property.listingType.rawValue)
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(property.status.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(getStatusColor(property.status))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(getStatusColor(property.status).opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text("Category: \(property.category)")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Property Details")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            
                            VStack(spacing: 8) {
                                DetailRow(title: "Listing Date", value: formatDate(property.listingDate))
                                DetailRow(title: "Expires On", value: formatDate(property.expirationDate))
                                DetailRow(title: "Duration", value: "\(property.listingDuration) days")
                                
                                if let highestBid = property.highestBid {
                                    DetailRow(title: "Highest Bid", value: "₹\(Int(highestBid))")
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text(property.description)
                                .font(.body)
                                .foregroundColor(Theme.textSecondary)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                                .padding(.horizontal)
                            
                            Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: region.center)]) { annotation in
                                MapPin(coordinate: annotation.coordinate, tint: .red)
                            }
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                            .onAppear {
                                setupMapRegion()
                            }
                            
                            Text(property.location)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                                .padding(.horizontal)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Listed by")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            
                            HStack {
                                Circle()
                                    .fill(Theme.primaryColor.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Text(String(property.ownerName.prefix(1)).uppercased())
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(Theme.primaryColor)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(property.ownerName)
                                        .font(.headline)
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    Text("Property Owner")
                                        .font(.subheadline)
                                        .foregroundColor(Theme.textSecondary)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
                .padding(.vertical, 8)
            }
            
            VStack {
                Divider()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("₹\(Int(property.price))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)
                        
                        Text(property.listingType.rawValue)
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    if property.status == .active {
                        Button(action: {
                            print("Contact owner for property: \(property.title)")
                        }) {
                            Text("Contact Owner")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Theme.primaryColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    } else {
                        Text("Not Available")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Theme.background)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            updateWishlistStatus()
        }
        .onChange(of: cloudkitViewModel.wishlistItems) { _ in
            updateWishlistStatus()
        }
    }
    
    private func updateWishlistStatus() {
        isWishlisted = cloudkitViewModel.isPropertyInWishlist(property)
    }
    
    private func toggleWishlist() {
        if isWishlisted {
            cloudkitViewModel.removeFromWishlist(property: property) { result in
                switch result {
                case .success:
                    print("Removed from wishlist")
                case .failure(let error):
                    print("Failed to remove from wishlist: \(error)")
                }
            }
        } else {
            cloudkitViewModel.addToWishlist(property: property) { result in
                switch result {
                case .success:
                    print("Added to wishlist")
                case .failure(let error):
                    print("Failed to add to wishlist: \(error)")
                }
            }
        }
    }
    
    private func getStatusColor(_ status: ListingStatus) -> Color {
        switch status {
        case .active:
            return .green
        case .pending:
            return .orange
        case .sold:
            return .red
        case .expired:
            return .gray
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func setupMapRegion() {
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090)
        
        region = MKCoordinateRegion(
            center: defaultCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        geocodeLocation(property.location)
    }
    
    private func geocodeLocation(_ locationString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { placemarks, error in
            if let placemark = placemarks?.first,
               let location = placemark.location {
                DispatchQueue.main.async {
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                }
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Theme.textPrimary)
        }
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    NavigationView {
        PropertyDetailView(property: PropertyListing(
            id: UUID(),
            recordID: nil,
            title: "Beautiful Modern Apartment",
            category: "Apartment",
            location: "Mumbai, Maharashtra",
            description: "A stunning modern apartment with all amenities and great city views.",
            listingType: .forRent,
            price: 50000,
            listingDuration: 30,
            listingDate: Date(),
            expirationDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
            status: .active,
            ownerID: "owner123",
            ownerName: "John Doe",
            photoURLs: [],
            bids: [],
            highestBid: nil
        ))
        .environmentObject(CloudkitManagerViewModel())
    }
}

