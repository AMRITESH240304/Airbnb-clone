//
//  AddPropertyViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 18/09/25.
//

import SwiftUI
import MapKit
import Combine

class AddPropertyViewModel: ObservableObject {
    private let cloudKitManager = CloudkitManagerViewModel()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var propertyTitle = ""
    @Published var propertyDescription = ""
    @Published var propertyPrice = ""
    @Published var selectedCategory = "House"
    @Published var selectedSubCategory = ""
    @Published var location = ""
    @Published var listingDuration = 14
    
    @Published var coordinate = CLLocationCoordinate2D()
    @Published var hasSetCoordinate = false
    
    @Published var listingType = "For Sale"
    
    @Published var monthlyRent = ""
    
    @Published var genderPreference = "Any"
    @Published var isStudentAccommodation = false
    
    @Published var isOverseas = false
    @Published var country = ""
    
    @Published var photoURLs: [String] = [""]
    
    @Published var showConfirmationAlert = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var wasListingAdded = false
    
    let listingTypes = ["For Sale", "For Rent"]
    
    // Gender options for student accommodation
    let genderOptions = ["Any", "Male Only", "Female Only"]
    
    // Property categories - expanded with more options
    let mainCategories = [
        "House",
        "Apartment",
        "Villa/Bungalow",
        "Studio",
        "Commercial Property",
        "Land/Farm",
        "Student Accommodation",
        "Overseas Property",
        "Retirement Home"
    ]
    
    let commercialSubcategories = [
        "Office Space",
        "Retail Shop / Storefront",
        "Industrial Property",
        "Warehouse / Storage Facility",
        "Restaurant / Café Space",
        "Hotel / Motel / Hospitality Property",
        "Mixed-Use Development",
        "Other Commercial Property"
    ]
    
    let professionalsCategories = [
        "Estate Agents",
        "Letting Agents",
        "Real Estate Consultants"
    ]
    
    let servicesCategories = [
        "Consultancy Services",
        "Business Partnerships / Collaborations",
        "Franchise Opportunities"
    ]
    
    func buildFullCategory() -> String {
        if selectedCategory == "Commercial Property" && !selectedSubCategory.isEmpty {
            return "\(selectedCategory) - \(selectedSubCategory)"
        } else {
            return selectedCategory
        }
    }
    
    func categoryChanged() {
        selectedSubCategory = ""
        
        isStudentAccommodation = (selectedCategory == "Student Accommodation")
        isOverseas = (selectedCategory == "Overseas Property")
    }
    
    func addPhotoURL() {
        if photoURLs.count < 6 {
            photoURLs.append("")
        }
    }
    
    func removePhotoURL(at index: Int) {
        if photoURLs.count > 1 {
            photoURLs.remove(at: index)
        }
    }
    
    var confirmationMessage: String {
        var message = """
        Title: \(propertyTitle)
        Type: \(buildFullCategory())
        Location: \(location)
        Listing Type: \(listingType)
        """
        
        if isStudentAccommodation {
            message += "\nGender Preference: \(genderPreference)"
        }
        
        if isOverseas {
            message += "\nCountry: \(country)"
        }
        
        if listingType == "For Sale" {
            message += "\nAsking Price: $\(propertyPrice)"
        } else {
            message += "\nMonthly Rent: $\(monthlyRent)"
        }
        
        message += "\nListing Duration: \(listingDuration) days"
        
        if hasSetCoordinate {
            message += "\nLocation coordinates set ✓"
        }
        
        return message
    }
    
    func submitProperty(completion: @escaping () -> Void) {
        isLoading = true
        
        let formData = PropertyFormData.fromFormData(
            title: propertyTitle,
            category: buildFullCategory(),
            location: location,
            description: propertyDescription,
            listingType: listingType,
            price: propertyPrice,
            monthlyRent: monthlyRent,
            listingDuration: listingDuration,
            photoURLs: photoURLs,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            isStudentAccommodation: isStudentAccommodation,
            genderPreference: isStudentAccommodation ? genderPreference : nil,
            isOverseas: isOverseas,
            country: isOverseas ? country : nil
        )
        
        cloudKitManager.createPropertyListing(from: formData) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            
            switch result {
            case .success(_):
                self.wasListingAdded = true
                self.showSuccessAlert = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showErrorAlert = true
            }
            
            completion()
        }
    }
}
