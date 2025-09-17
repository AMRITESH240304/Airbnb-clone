//
//  AddPropertyView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 17/09/25.
//

import SwiftUI

struct AddPropertyView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cloudKitManager = CloudkitManagerViewModel()
    
    // Property details
    @State private var propertyTitle = ""
    @State private var propertyDescription = ""
    @State private var propertyPrice = ""
    @State private var selectedCategory = "House"
    @State private var location = ""
    @State private var listingDuration = 14 // Default 14 days
    
    // Property listing type
    @State private var listingType = "For Sale"
    let listingTypes = ["For Sale", "For Rent"]
    
    // Monthly rent (only for rental properties)
    @State private var monthlyRent = ""
    
    // Photo URLs (limited to 6)
    @State private var photoURLs: [String] = [""]
    
    // Alert states
    @State private var showConfirmationAlert = false
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    
    // Property categories
    let categories = ["House", "Apartment", "Villa", "Bungalow", "Studio", "Commercial", "Land/Farm"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Property details form
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Property Title")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter property title", text: $propertyTitle)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Listing Type (Sale/Rent)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Listing Type")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            Picker("Listing Type", selection: $listingType) {
                                ForEach(listingTypes, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // Category
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Property Type")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category).tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        // Location
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter property location", text: $location)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Price (for sale) or Monthly Rent (for rent)
                        if listingType == "For Sale" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Asking Price ($)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                TextField("Enter asking price", text: $propertyPrice)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Monthly Rent ($)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                TextField("Enter monthly rent", text: $monthlyRent)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Listing duration
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Listing Duration (days)")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            Picker("", selection: $listingDuration) {
                                Text("7 days").tag(7)
                                Text("14 days").tag(14)
                                Text("30 days").tag(30)
                                Text("60 days").tag(60)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextEditor(text: $propertyDescription)
                                .frame(minHeight: 100)
                                .padding(4)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Photo URLs (up to 6)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Photo URLs (max 6)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                Spacer()
                                
                                if photoURLs.count < 6 {
                                    Button {
                                        if photoURLs.count < 6 {
                                            photoURLs.append("")
                                        }
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Theme.primaryColor)
                                    }
                                }
                            }
                            
                            ForEach(0..<photoURLs.count, id: \.self) { index in
                                HStack {
                                    TextField("Enter photo URL #\(index + 1)", text: $photoURLs[index])
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    
                                    if photoURLs.count > 1 {
                                        Button {
                                            photoURLs.remove(at: index)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Submit button
                        Button(action: {
                            showConfirmationAlert = true
                        }) {
                            if cloudKitManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("List Property")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Theme.primaryColor)
                        )
                        .disabled(cloudKitManager.isLoading)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .background(Theme.background)
            .navigationTitle("List Your Property")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.primaryColor)
                }
            }
            .alert("Confirm Property Details", isPresented: $showConfirmationAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Confirm") {
                    // Create the form data
                    let formData = PropertyFormData.fromFormData(
                        title: propertyTitle,
                        category: selectedCategory,
                        location: location,
                        description: propertyDescription,
                        listingType: listingType,
                        price: propertyPrice,
                        monthlyRent: monthlyRent,
                        listingDuration: listingDuration,
                        photoURLs: photoURLs
                    )
                    
                    // Save to CloudKit
                    cloudKitManager.createPropertyListing(from: formData) { result in
                        switch result {
                        case .success(_):
                            showSuccessAlert = true
                        case .failure(_):
                            showErrorAlert = true
                        }
                    }
                }
            } message: {
                Text(confirmationMessage)
            }
            .alert("Property Listed Successfully", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your property has been listed and is now visible to potential buyers.")
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") { }
            } message: {
                Text(cloudKitManager.errorMessage ?? "An unknown error occurred")
            }
        }
    }
    
    // Create a formatted confirmation message from all the property details
    private var confirmationMessage: String {
        var message = """
        Title: \(propertyTitle)
        Type: \(selectedCategory)
        Location: \(location)
        Listing Type: \(listingType)
        """
        
        if listingType == "For Sale" {
            message += "\nAsking Price: $\(propertyPrice)"
        } else {
            message += "\nMonthly Rent: $\(monthlyRent)"
        }
        
        message += "\nListing Duration: \(listingDuration) days"
        
        return message
    }
}

#Preview {
    AddPropertyView()
}
