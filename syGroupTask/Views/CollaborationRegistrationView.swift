import SwiftUI

struct CollaborationRegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var formData = CollaborationRegistrationFormData()
    @State private var isProcessingPayment = false
    @State private var showingPaymentAlert = false
    @State private var paymentMessage = ""
    @State private var paymentSuccess = false
    
    let supportOptions = [
        "Training & Support", "Marketing Materials", "Technology Platform",
        "Legal Support", "Financial Assistance", "Territory Protection",
        "Ongoing Mentorship", "Sales Support", "Operational Guidance"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Payment Info Section
                    VStack(spacing: 16) {
                        Image(systemName: "building.2")
                            .font(.system(size: 50))
                            .foregroundColor(Theme.primaryColor)
                        
                        Text("Business Collaboration Registration")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Registration Fee: ₹\(Int(RevenueConfig.collaborationRegistrationFee))")
                            .font(.headline)
                            .foregroundColor(Theme.primaryColor)
                        
                        Text("Join our network of real estate collaborators and explore partnership opportunities")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Business Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Business Information")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            TextField("Business Name", text: $formData.businessName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Picker("Business Type", selection: $formData.businessType) {
                                ForEach(BusinessType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            Picker("Collaboration Type", selection: $formData.collaborationType) {
                                ForEach(CollaborationType.allCases) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            TextField("Location", text: $formData.location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Contact Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Information")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            TextField("Contact Email", text: $formData.contactEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                            
                            TextField("Contact Phone", text: $formData.contactPhone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                            
                            TextField("Website (Optional)", text: $formData.website)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.URL)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Business Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Business Details")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 12) {
                            TextField("Business Description", text: $formData.description, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3...6)
                            
                            Picker("Investment Range", selection: $formData.investmentRange) {
                                ForEach(InvestmentRange.allCases) { range in
                                    Text(range.rawValue).tag(range)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            
                            TextField("Expected ROI", text: $formData.expectedROI)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Business Model", text: $formData.businessModel, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(2...4)
                            
                            TextField("Experience Required", text: $formData.experienceRequired)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Support Provided
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Support Provided")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(supportOptions, id: \.self) { option in
                                Button(action: {
                                    if formData.supportProvided.contains(option) {
                                        formData.supportProvided.remove(option)
                                    } else {
                                        formData.supportProvided.insert(option)
                                    }
                                }) {
                                    Text(option)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(formData.supportProvided.contains(option) ? Theme.primaryColor : Color(.systemGray5))
                                        .foregroundColor(formData.supportProvided.contains(option) ? .white : Theme.textPrimary)
                                        .cornerRadius(16)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Register Button
                    Button(action: {
                        processRegistration()
                    }) {
                        HStack {
                            if isProcessingPayment {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            
                            Text(isProcessingPayment ? "Processing..." : "Pay ₹\(Int(RevenueConfig.collaborationRegistrationFee)) & Register")
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isProcessingPayment ? Color.gray : Theme.primaryColor)
                        .cornerRadius(12)
                    }
                    .disabled(isProcessingPayment || !isFormValid)
                }
                .padding()
            }
            .navigationTitle("Business Registration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert(paymentSuccess ? "Registration Successful!" : "Registration Info", isPresented: $showingPaymentAlert) {
            Button("OK") {
                if paymentSuccess {
                    dismiss()
                }
            }
        } message: {
            Text(paymentMessage)
        }
    }
    
    private var isFormValid: Bool {
        !formData.businessName.isEmpty &&
        !formData.description.isEmpty &&
        !formData.location.isEmpty &&
        !formData.contactEmail.isEmpty &&
        !formData.contactPhone.isEmpty &&
        !formData.expectedROI.isEmpty &&
        !formData.businessModel.isEmpty &&
        !formData.experienceRequired.isEmpty
    }
    
    private func processRegistration() {
        isProcessingPayment = true
        
        cloudkitViewModel.processCollaborationRegistrationPayment { [self] paymentResult in
            switch paymentResult {
            case .success(_):
                // Payment successful, now create collaboration profile
                cloudkitViewModel.createCollaborationProfile(from: formData) { [self] profileResult in
                    DispatchQueue.main.async {
                        self.isProcessingPayment = false
                        
                        switch profileResult {
                        case .success(_):
                            self.paymentMessage = "Registration successful! Your collaboration profile is now active."
                            self.paymentSuccess = true
                            self.showingPaymentAlert = true
                            
                        case .failure(let error):
                            self.paymentMessage = "Profile creation failed: \(error.localizedDescription)"
                            self.paymentSuccess = false
                            self.showingPaymentAlert = true
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isProcessingPayment = false
                    self.paymentMessage = "Payment failed: \(error.localizedDescription)"
                    self.paymentSuccess = false
                    self.showingPaymentAlert = true
                }
            }
        }
    }
}