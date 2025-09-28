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
    @EnvironmentObject var authManager: AuthManagerViewModel
    @StateObject private var viewModel: PropertyDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingDatePicker = false
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    @State private var dateSelectionMode: DateAndGuestSection.DateSelectionMode = .dates
    @State private var flexibilityOption: DateAndGuestSection.FlexibilityOption = .exactDates
    
    // New state for login alert
    @State private var showingLoginAlert = false
    
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
            
            PropertyBottomActionBar(
                property: property,
                viewModel: viewModel,
                showingDatePicker: Binding(
                    get: { showingDatePicker },
                    set: { newValue in
                        if newValue {
                            if authManager.isAuthenticated {
                                showingDatePicker = true
                            } else {
                                showingLoginAlert = true
                            }
                        } else {
                            showingDatePicker = false
                        }
                    }
                ),
                selectedStartDate: $selectedStartDate,
                selectedEndDate: $selectedEndDate
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showingDatePicker) {
            DatePickerView(
                selectedStartDate: $selectedStartDate,
                selectedEndDate: $selectedEndDate,
                dateSelectionMode: $dateSelectionMode,
                flexibilityOption: $flexibilityOption,
                isPresented: $showingDatePicker,
                property: property,
                onPaymentAction: { startDate, endDate in
                    processPaymentWithDates(startDate: startDate, endDate: endDate)
                }
            )
        }
        .alert("Please login", isPresented: $showingLoginAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You need to log in to book this property.")
        }
        .onAppear {
            viewModel.setCloudkitViewModel(cloudkitViewModel)
            viewModel.updateWishlistStatus()
            cloudkitViewModel.fetchUserPayments(forceRefresh: true)
        }
        .onChange(of: cloudkitViewModel.wishlistItems) { _ in
            viewModel.updateWishlistStatus()
        }
        .onChange(of: cloudkitViewModel.userPayments) { _ in
            viewModel.updateWishlistStatus()
        }
        .alert(viewModel.paymentSuccess ? "Payment Successful!" : "Payment Info", isPresented: $viewModel.showingPaymentAlert) {
            Button("OK") {
                if viewModel.paymentSuccess {
                    cloudkitViewModel.fetchUserPayments(forceRefresh: true)
                }
            }
        } message: {
            Text(viewModel.paymentMessage)
        }
    }
    
    private func processPaymentWithDates(startDate: Date?, endDate: Date?) {
        viewModel.isProcessingPayment = true
        
        cloudkitViewModel.processContactOwnerPayment(
            property: property,
            bookingStartDate: startDate,
            bookingEndDate: endDate
        ) { result in
            DispatchQueue.main.async {
                viewModel.isProcessingPayment = false
                
                switch result {
                case .success(_):
                    viewModel.paymentSuccess = true
                    viewModel.paymentMessage = "Payment successful! You can now contact the property owner."
                    
                case .failure(let error):
                    viewModel.paymentSuccess = false
                    viewModel.paymentMessage = "Payment failed: \(error.localizedDescription)"
                }
                
                viewModel.showingPaymentAlert = true
            }
        }
    }
}
