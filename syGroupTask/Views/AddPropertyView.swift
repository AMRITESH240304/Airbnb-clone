//
//  AddPropertyView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 17/09/25.
//

import SwiftUI
import MapKit

struct AddPropertyView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddPropertyViewModel()
    @Binding var wasListingAdded: Bool
    @State private var showLocationPicker = false
    
    // For preview and default initialization without binding
    init(wasListingAdded: Binding<Bool> = .constant(false)) {
        self._wasListingAdded = wasListingAdded
    }
    
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
                            
                            TextField("Enter property title", text: $viewModel.propertyTitle)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Listing Type (Sale/Rent)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Listing Type")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            Picker("Listing Type", selection: $viewModel.listingType) {
                                ForEach(viewModel.listingTypes, id: \.self) { type in
                                    Text(type).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        // Main Category
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Property Type")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            Picker("Category", selection: $viewModel.selectedCategory) {
                                ForEach(viewModel.mainCategories, id: \.self) { category in
                                    Text(category).tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: viewModel.selectedCategory) { _ in
                                viewModel.categoryChanged()
                            }
                        }
                        
                        // Subcategory for Commercial Property
                        if viewModel.selectedCategory == "Commercial Property" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Commercial Property Type")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                Picker("Subcategory", selection: $viewModel.selectedSubCategory) {
                                    Text("Select type").tag("")
                                    ForEach(viewModel.commercialSubcategories, id: \.self) { subcategory in
                                        Text(subcategory).tag(subcategory)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        
                        // Student Accommodation specific fields
                        if viewModel.isStudentAccommodation {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Gender Preference")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                Picker("Gender", selection: $viewModel.genderPreference) {
                                    ForEach(viewModel.genderOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                        }
                        
                        // Overseas Property specific fields
                        if viewModel.isOverseas {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Country")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                TextField("Enter country", text: $viewModel.country)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Location with map integration
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextField("Enter property location", text: $viewModel.location)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            Button {
                                showLocationPicker = true
                            } label: {
                                HStack {
                                    Image(systemName: "map")
                                    Text(viewModel.hasSetCoordinate ? "Change Location on Map" : "Set Location on Map")
                                }
                                .foregroundColor(Theme.primaryColor)
                                .padding(.vertical, 4)
                            }
                            
                            if viewModel.hasSetCoordinate {
                                VStack {
                                    Map {
                                        Marker("Property Location", coordinate: viewModel.coordinate)
                                    }
                                    .frame(height: 150)
                                    .cornerRadius(8)
                                    
                                    Text("Coordinates: \(String(format: "%.5f", viewModel.coordinate.latitude)), \(String(format: "%.5f", viewModel.coordinate.longitude))")
                                        .font(.caption)
                                        .foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                        
                        // Price (for sale) or Monthly Rent (for rent)
                        if viewModel.listingType == "For Sale" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Asking Price ($)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                TextField("Enter asking price", text: $viewModel.propertyPrice)
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
                                
                                TextField("Enter monthly rent", text: $viewModel.monthlyRent)
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
                            
                            Picker("", selection: $viewModel.listingDuration) {
                                Text("7 days").tag(7)
                                Text("14 days").tag(14)
                                Text("30 days").tag(30)
                                Text("60 days").tag(60)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            TextEditor(text: $viewModel.propertyDescription)
                                .frame(minHeight: 100)
                                .padding(4)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Photo URLs (max 6)")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                                
                                Spacer()
                                
                                if viewModel.photoURLs.count < 6 {
                                    Button {
                                        viewModel.addPhotoURL()
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(Theme.primaryColor)
                                    }
                                }
                            }
                            
                            ForEach(0..<viewModel.photoURLs.count, id: \.self) { index in
                                HStack {
                                    TextField("Enter photo URL #\(index + 1)", text: $viewModel.photoURLs[index])
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    
                                    if viewModel.photoURLs.count > 1 {
                                        Button {
                                            viewModel.removePhotoURL(at: index)
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Button(action: {
                            viewModel.showConfirmationAlert = true
                        }) {
                            if viewModel.isLoading {
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
                        .disabled(viewModel.isLoading)
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
            .sheet(isPresented: $showLocationPicker) {
                LocationPickerView(
                    coordinate: $viewModel.coordinate,
                    location: $viewModel.location,
                    hasSetCoordinate: $viewModel.hasSetCoordinate
                )
                .presentationDetents([.large])
            }
            .alert("Confirm Property Details", isPresented: $viewModel.showConfirmationAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Confirm") {
                    viewModel.submitProperty {
                    }
                }
            } message: {
                Text(viewModel.confirmationMessage)
            }
            .alert("Property Listed Successfully", isPresented: $viewModel.showSuccessAlert) {
                Button("OK") {
                    wasListingAdded = viewModel.wasListingAdded
                    dismiss()
                }
            } message: {
                Text("Your property has been listed and is now visible to potential buyers.")
            }
            .alert("Error", isPresented: $viewModel.showErrorAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }
}

#Preview {
    AddPropertyView()
}
