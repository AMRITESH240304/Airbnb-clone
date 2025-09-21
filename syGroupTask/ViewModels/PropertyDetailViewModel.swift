//
//  PropertyDetailViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 20/09/25.
//

import SwiftUI
import MapKit
import CoreLocation

class PropertyDetailViewModel: ObservableObject {
    @Published var propertyDetail: PropertyDetail
    @Published var isLoading = false
    @Published var currentImageIndex = 0
    @Published var isWishlisted: Bool = false
    @Published var region = MKCoordinateRegion()
    @Published var showingContactSheet = false
    @Published var showingPaymentAlert = false
    @Published var paymentMessage: String = ""
    @Published var isProcessingPayment = false
    @Published var paymentSuccess = false
    
    private let cardId: UUID
    private let property: PropertyListing
    private var cloudkitViewModel: CloudkitManagerViewModel?
    private let imageCache = ImageCacheManager.shared
    
    init(cardId: UUID, property: PropertyListing) {
        self.cardId = cardId
        self.property = property
        self.propertyDetail = MockData.getPropertyDetailOrDefault(for: cardId)
        
        setupInitialState()
        preloadPropertyImages()
    }
    
    // Add this function to set cloudkit from environment
    func setCloudkitViewModel(_ viewModel: CloudkitManagerViewModel) {
        self.cloudkitViewModel = viewModel
        // Fetch user payments when CloudKit is set
        viewModel.fetchUserPayments()
    }
    
    // MARK: - Setup Methods
    
    private func setupInitialState() {
        setupMapRegion()
    }
    
    func setupMapRegion() {
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090)
        
        region = MKCoordinateRegion(
            center: defaultCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        geocodeLocation(property.location)
    }
    
    private func geocodeLocation(_ locationString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let placemark = placemarks?.first,
               let location = placemark.location {
                DispatchQueue.main.async {
                    self.region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                }
            }
        }
    }
    
    // MARK: - Wishlist Methods
    
    func updateWishlistStatus() {
        guard let cloudkitViewModel = cloudkitViewModel else { return }
        isWishlisted = cloudkitViewModel.isPropertyInWishlist(property)
    }
    
    func toggleWishlist() {
        guard let cloudkitViewModel = cloudkitViewModel else { return }
        
        if isWishlisted {
            cloudkitViewModel.removeFromWishlist(property: property) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.updateWishlistStatus()
                    case .failure(let error):
                        print("Failed to remove from wishlist: \(error)")
                    }
                }
            }
        } else {
            cloudkitViewModel.addToWishlist(property: property) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.updateWishlistStatus()
                    case .failure(let error):
                        print("Failed to add to wishlist: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - Property Status Methods
    
    func getStatusColor(_ status: ListingStatus) -> Color {
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
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    // MARK: - Contact/Payment Methods
    
    func isCurrentUserOwner() -> Bool {
        guard let cloudkitViewModel = cloudkitViewModel else { return false }
        return cloudkitViewModel.isPropertyOwnedByCurrentUser(property)
    }
    
    func canUserContactOwner() -> Bool {
        guard let cloudkitViewModel = cloudkitViewModel else { return false }
        return cloudkitViewModel.canUserContactOwner(property: property)
    }
    
    func hasUserPaidForContact() -> Bool {
        guard let cloudkitViewModel = cloudkitViewModel else { return false }
        return cloudkitViewModel.hasUserPaidForContact(property: property)
    }
    
    func processPayment() {
        guard let cloudkitViewModel = cloudkitViewModel else { return }
        
        isProcessingPayment = true
        paymentMessage = ""
        
        cloudkitViewModel.processContactOwnerPayment(property: property) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isProcessingPayment = false
                
                switch result {
                case .success(let payment):
                    self.paymentSuccess = true
                    self.paymentMessage = "Payment Successful! ₹\(Int(payment.amount)) paid to \(payment.recipientName).\n\nContact Details:\nPhone: +91 98765 43210\nEmail: owner@example.com"
                    self.showingPaymentAlert = true
                    // Refresh payments after successful payment
                    cloudkitViewModel.fetchUserPayments(forceRefresh: true)
                case .failure(let error):
                    self.paymentSuccess = false
                    self.paymentMessage = "Payment failed: \(error.localizedDescription)"
                    self.showingPaymentAlert = true
                }
            }
        }
    }
    
    func showContactDetails() {
        showingContactSheet = true
    }
    
    // MARK: - Button State Methods
    
    func getButtonText() -> String {
        if isCurrentUserOwner() {
            return "Your Property"
        } else if hasUserPaidForContact() {
            return "Contact Owner"
        } else {
            return "Pay ₹\(Int(RevenueConfig.contactOwnerFee))"
        }
    }
    
    func getButtonColor() -> Color {
        if isCurrentUserOwner() {
            return Color.gray.opacity(0.2)
        } else if hasUserPaidForContact() {
            return Color.green
        } else {
            return Theme.primaryColor
        }
    }
    
    func getButtonTextColor() -> Color {
        if isCurrentUserOwner() {
            return Theme.textSecondary
        } else {
            return .white
        }
    }
    
    func isButtonDisabled() -> Bool {
        return isCurrentUserOwner() || isProcessingPayment
    }
    
    func handleButtonAction() {
        if isCurrentUserOwner() {
            return
        } else if hasUserPaidForContact() {
            paymentMessage = "Contact Owner: \(property.ownerName)\nPhone: +91 98765 43210\nEmail: owner@example.com"
            showingPaymentAlert = true
        } else {
            processPayment()
        }
    }
    
    func refreshPropertyData() {
        isLoading = true
        
        Task {
            try await Task.sleep(nanoseconds: 500_000_000)
            
            propertyDetail = MockData.getPropertyDetailOrDefault(for: cardId)
            
            preloadPropertyImages()
            
            isLoading = false
        }
    }
    
    func nextImage() {
        let nextIndex = (currentImageIndex + 1) % propertyDetail.images.count
        currentImageIndex = nextIndex
    }
    
    func previousImage() {
        let previousIndex = currentImageIndex > 0 ? currentImageIndex - 1 : propertyDetail.images.count - 1
        currentImageIndex = previousIndex
    }
    
    func selectImage(at index: Int) {
        currentImageIndex = index
    }
    
    // MARK: - Image Preloading
    
    private func preloadPropertyImages() {
        Task {
            for imageUrl in propertyDetail.images {
                
            }
        }
    }
}
