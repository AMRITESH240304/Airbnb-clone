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
    @StateObject private var viewModel: PropertyDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(property: PropertyListing) {
        self.property = property
        self._viewModel = StateObject(wrappedValue: PropertyDetailViewModel(
            cardId: UUID(), 
            property: property
        ))
    }
    
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
                    viewModel.toggleWishlist()
                } label: {
                    Image(systemName: viewModel.isWishlisted ? "heart.fill" : "heart")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(viewModel.isWishlisted ? .red : Theme.textPrimary)
                }
                .padding(.trailing)
            }
            .padding(.top, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    PropertyImageCarousel(photoURLs: property.photoURLs)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        PropertyHeaderSection(property: property)
                        
                        Divider()
                        
                        PropertyPriceSection(property: property, viewModel: viewModel)
                        
                        Divider()
                        
                        PropertyDetailsSection(property: property, viewModel: viewModel)
                        
                        Divider()
                        
                        PropertyDescriptionSection(property: property)
                        
                        Divider()
                        
                        PropertyLocationSection(property: property, region: $viewModel.region)
                        
                        Divider()
                        
                        PropertyOwnerSection(property: property)
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
                .padding(.vertical, 8)
            }
            
            PropertyBottomActionBar(property: property, viewModel: viewModel)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            // Set the cloudkit instance in viewModel from environment
            viewModel.setCloudkitViewModel(cloudkitViewModel)
            viewModel.updateWishlistStatus()
            // Force refresh user payments to get latest payment status
            cloudkitViewModel.fetchUserPayments(forceRefresh: true)
        }
        .onChange(of: cloudkitViewModel.wishlistItems) { _ in
            viewModel.updateWishlistStatus()
        }
        .onChange(of: cloudkitViewModel.userPayments) { _ in
            // Force UI update when payments change
            viewModel.updateWishlistStatus()
        }
        .alert(viewModel.paymentSuccess ? "Payment Successful!" : "Payment Info", isPresented: $viewModel.showingPaymentAlert) {
            Button("OK") { 
                // Refresh payments after successful payment
                if viewModel.paymentSuccess {
                    cloudkitViewModel.fetchUserPayments(forceRefresh: true)
                }
            }
        } message: {
            Text(viewModel.paymentMessage)
        }
    }
}

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

struct PropertyHeaderSection: View {
    let property: PropertyListing
    
    var body: some View {
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
    }
}

struct PropertyPriceSection: View {
    let property: PropertyListing
    let viewModel: PropertyDetailViewModel
    
    var body: some View {
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
                    .foregroundColor(viewModel.getStatusColor(property.status))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(viewModel.getStatusColor(property.status).opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("Category: \(property.category)")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(.horizontal)
    }
}

struct PropertyDetailsSection: View {
    let property: PropertyListing
    let viewModel: PropertyDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Property Details")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: 8) {
                DetailRow(title: "Listing Date", value: viewModel.formatDate(property.listingDate))
                DetailRow(title: "Expires On", value: viewModel.formatDate(property.expirationDate))
                DetailRow(title: "Duration", value: "\(property.listingDuration) days")
                
                if let highestBid = property.highestBid {
                    DetailRow(title: "Highest Bid", value: "₹\(Int(highestBid))")
                }
            }
        }
        .padding(.horizontal)
    }
}

struct PropertyDescriptionSection: View {
    let property: PropertyListing
    
    var body: some View {
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
    }
}

struct PropertyLocationSection: View {
    let property: PropertyListing
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
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
            
            Text(property.location)
                .font(.subheadline)
                .foregroundColor(Theme.textSecondary)
                .padding(.horizontal)
        }
    }
}

struct PropertyOwnerSection: View {
    let property: PropertyListing
    
    var body: some View {
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
    }
}

struct PropertyBottomActionBar: View {
    let property: PropertyListing
    let viewModel: PropertyDetailViewModel
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    
    var body: some View {
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
                        viewModel.handleButtonAction()
                    }) {
                        HStack {
                            if viewModel.isProcessingPayment {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            
                            HStack(spacing: 8) {
                                if cloudkitViewModel.hasUserPaidForContact(property: property) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "indianrupeesign.circle")
                                        .foregroundColor(.white)
                                }
                                Text(cloudkitViewModel.hasUserPaidForContact(property: property) ? "Contact Owner" : "Pay to Contact")
                            }
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(cloudkitViewModel.hasUserPaidForContact(property: property) ? Color.green : Theme.primaryColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(viewModel.isProcessingPayment || cloudkitViewModel.isPropertyOwnedByCurrentUser(property))
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
