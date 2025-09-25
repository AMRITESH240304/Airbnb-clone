import SwiftUI

struct ProfessionalRegistrationView: View {
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfessionalRegistrationViewModel()
    @State private var currentStep: RegistrationStep = .basicInfo
    
    var body: some View {
        NavigationView {
            VStack {
                ProgressIndicatorView(currentStep: currentStep)
                
                ScrollView {
                    VStack(spacing: 24) {
                        switch currentStep {
                        case .basicInfo:
                            BasicInfoStepView(formData: $viewModel.formData)
                        case .services:
                            ServicesStepView(formData: $viewModel.formData)
                        case .portfolio:
                            PortfolioStepView(formData: $viewModel.formData)
                        case .payment:
                            PaymentStepView(formData: $viewModel.formData, viewModel: viewModel)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    if currentStep != .basicInfo {
                        Button("Back") {
                            withAnimation {
                                currentStep = currentStep.previous()
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    Spacer()
                    
                    Button(currentStep == .payment ? "Register & Pay" : "Next") {
                        if currentStep == .payment {
                            viewModel.registerProfessional(cloudkitViewModel: cloudkitViewModel) { success in
                                if success {
                                    dismiss()
                                }
                            }
                        } else {
                            withAnimation {
                                currentStep = currentStep.next()
                            }
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!viewModel.canProceedToNext(from: currentStep))
                }
                .padding()
            }
            .navigationTitle("Become a Professional")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .alert("Registration Status", isPresented: $viewModel.showingAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

enum RegistrationStep: CaseIterable {
    case basicInfo, services, portfolio, payment
    
    func next() -> RegistrationStep {
        let allCases = RegistrationStep.allCases
        guard let currentIndex = allCases.firstIndex(of: self),
              currentIndex < allCases.count - 1 else {
            return self
        }
        return allCases[currentIndex + 1]
    }
    
    func previous() -> RegistrationStep {
        let allCases = RegistrationStep.allCases
        guard let currentIndex = allCases.firstIndex(of: self),
              currentIndex > 0 else {
            return self
        }
        return allCases[currentIndex - 1]
    }
}

struct ProgressIndicatorView: View {
    let currentStep: RegistrationStep
    
    var body: some View {
        HStack {
            ForEach(Array(RegistrationStep.allCases.enumerated()), id: \.element) { index, step in
                Circle()
                    .fill(stepIndex(step) <= stepIndex(currentStep) ? Theme.primaryColor : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
                
                if index < RegistrationStep.allCases.count - 1 {
                    Rectangle()
                        .fill(stepIndex(step) < stepIndex(currentStep) ? Theme.primaryColor : Color.gray.opacity(0.3))
                        .frame(height: 2)
                }
            }
        }
        .padding()
    }
    
    private func stepIndex(_ step: RegistrationStep) -> Int {
        RegistrationStep.allCases.firstIndex(of: step) ?? 0
    }
}

struct BasicInfoStepView: View {
    @Binding var formData: ProfessionalRegistrationFormData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Basic Information")
                .font(.title2)
                .fontWeight(.bold)
            
            FormField(title: "Business Name", text: $formData.businessName, placeholder: "Enter your business name")
            
            FormField(title: "Description", text: $formData.description, placeholder: "Describe your services", axis: .vertical)
            
            FormField(title: "Phone Number", text: $formData.phoneNumber, placeholder: "Enter phone number")
            
            FormField(title: "Email", text: $formData.email, placeholder: "Enter email address")
            
            FormField(title: "Location", text: $formData.location, placeholder: "Enter your location")
            
            FormField(title: "Website (Optional)", text: $formData.website, placeholder: "Enter website URL")
            
            FormField(title: "Years of Experience", text: $formData.experience, placeholder: "Enter years of experience")
        }
    }
}

struct ServicesStepView: View {
    @Binding var formData: ProfessionalRegistrationFormData
    @State private var showingAddService = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Services & Categories")
                .font(.title2)
                .fontWeight(.bold)
        
            Text("Select Service Categories")
                .font(.headline)
            
            Text("Choose at least one category that best describes your services")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(ServiceCategory.allCases) { category in
                    CategorySelectionCard(
                        category: category,
                        isSelected: formData.selectedCategories.contains(category)
                    ) {
                        if formData.selectedCategories.contains(category) {
                            formData.selectedCategories.remove(category)
                        } else {
                            formData.selectedCategories.insert(category)
                        }
                    }
                }
            }
            
            HStack {
                Text("Your Services (Optional)")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    showingAddService = true
                }) {
                    Label("Add Service", systemImage: "plus")
                        .font(.subheadline)
                        .foregroundColor(Theme.primaryColor)
                }
            }
            
            Text("You can add specific services you offer with pricing. This is optional - you can add them later from your profile.")
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
            
            if formData.services.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "briefcase")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.textSecondary)
                    
                    Text("No services added yet")
                        .foregroundColor(Theme.textSecondary)
                        .font(.subheadline)
                    
                    Text("Add services to showcase your offerings")
                        .foregroundColor(Theme.textSecondary)
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            } else {
                ForEach(formData.services.indices, id: \.self) { index in
                    ServiceCard(service: formData.services[index]) {
                        formData.services.remove(at: index)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddService) {
            AddServiceView(services: $formData.services, availableCategories: Array(formData.selectedCategories))
        }
    }
}

struct PortfolioStepView: View {
    @Binding var formData: ProfessionalRegistrationFormData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Portfolio (Optional)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Add photos of your work to showcase your skills. You can skip this step and add portfolio images later from your profile.")
                .foregroundColor(Theme.textSecondary)
            
            Button(action: {
            }) {
                VStack(spacing: 12) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.primaryColor)
                    
                    Text("Add Portfolio Images")
                        .foregroundColor(Theme.primaryColor)
                        .font(.headline)
                    
                    Text("Optional - Showcase your work")
                        .foregroundColor(Theme.textSecondary)
                        .font(.caption)
                }
                .frame(height: 150)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                )
            }
            
            if !formData.portfolioImages.isEmpty {
                Text("Portfolio Images: \(formData.portfolioImages.count)")
                    .font(.subheadline)
                    .foregroundColor(Theme.primaryColor)
            }
        }
    }
}

struct PaymentStepView: View {
    @Binding var formData: ProfessionalRegistrationFormData
    let viewModel: ProfessionalRegistrationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Registration Payment")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                PricingCard(
                    title: "Professional Registration",
                    price: RevenueConfig.professionalRegistrationFee,
                    features: [
                        "Professional profile listing",
                        "Service showcase",
                        "Customer reviews",
                        "Direct contact from clients",
                        "Basic analytics"
                    ]
                )
                
                Toggle("I agree to the Terms and Conditions", isOn: $formData.agreedToTerms)
                    .toggleStyle(SwitchToggleStyle())
            }
            
            if viewModel.isProcessingPayment {
                ProgressView("Processing payment...")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct CategorySelectionCard: View {
    let category: ServiceCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : Theme.primaryColor)
                
                Text(category.rawValue)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? .white : Theme.textPrimary)
            }
            .padding()
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Theme.primaryColor : Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.primaryColor : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct ServiceCard: View {
    let service: ProfessionalService
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name)
                    .font(.headline)
                
                Text(service.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Text("₹\(Int(service.price))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.primaryColor)
                    
                    Text("• \(service.duration)")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct PricingCard: View {
    let title: String
    let price: Double
    let features: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                
                Text("₹\(Int(price))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryColor)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(feature)
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Theme.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray.opacity(0.2))
            .foregroundColor(Theme.textPrimary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
