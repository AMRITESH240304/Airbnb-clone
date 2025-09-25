//
//  PropertyBottomActionBar.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI
import MapKit

struct PropertyBottomActionBar: View {
    let property: PropertyListing
    let viewModel: PropertyDetailViewModel
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    
    @Binding var showingDatePicker: Bool
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?
    
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
                        handleButtonAction()
                    }) {
                        HStack {
                            if viewModel.isProcessingPayment {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            
                            HStack(spacing: 8) {
                                if cloudkitViewModel.isPropertyOwnedByCurrentUser(property) {
                                    Image(systemName: "house.fill")
                                        .foregroundColor(.white)
                                } else if cloudkitViewModel.hasUserPaidForContact(property: property) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "indianrupeesign.circle")
                                        .foregroundColor(.white)
                                }
                                Text(cloudkitViewModel.isPropertyOwnedByCurrentUser(property) ? "It's your property" : (cloudkitViewModel.hasUserPaidForContact(property: property) ? "Contact Owner" : "Pay to Contact"))
                            }
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(cloudkitViewModel.isPropertyOwnedByCurrentUser(property) ? Color.blue : (cloudkitViewModel.hasUserPaidForContact(property: property) ? Color.green : Theme.primaryColor))
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
    
    private func handleButtonAction() {
        if cloudkitViewModel.isPropertyOwnedByCurrentUser(property) {
            return
        } else if cloudkitViewModel.hasUserPaidForContact(property: property) {
            viewModel.handleButtonAction()
        } else {
            showingDatePicker = true
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
