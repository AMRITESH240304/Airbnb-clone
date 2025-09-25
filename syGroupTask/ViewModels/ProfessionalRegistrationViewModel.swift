import SwiftUI
import Foundation

class ProfessionalRegistrationViewModel: ObservableObject {
    @Published var formData = ProfessionalRegistrationFormData()
    @Published var isProcessingPayment = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    func canProceedToNext(from step: RegistrationStep) -> Bool {
        switch step {
        case .basicInfo:
            return !formData.businessName.isEmpty &&
                   !formData.description.isEmpty &&
                   !formData.phoneNumber.isEmpty &&
                   !formData.email.isEmpty &&
                   !formData.location.isEmpty &&
                   !formData.experience.isEmpty
        case .services:
            return !formData.selectedCategories.isEmpty
        case .portfolio:
            return true
        case .payment:
            return formData.agreedToTerms
        }
    }
    
    func registerProfessional(cloudkitViewModel: CloudkitManagerViewModel, completion: @escaping (Bool) -> Void) {
        guard canProceedToNext(from: .payment) else {
            alertMessage = "Please agree to the terms and conditions"
            showingAlert = true
            completion(false)
            return
        }
        
        isProcessingPayment = true
        
        cloudkitViewModel.processProfessionalRegistrationPayment { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    self.createProfessionalProfile(cloudkitViewModel: cloudkitViewModel, completion: completion)
                case .failure(let error):
                    self.isProcessingPayment = false
                    self.alertMessage = "Payment failed: \(error.localizedDescription)"
                    self.showingAlert = true
                    completion(false)
                }
            }
        }
    }
    
    private func createProfessionalProfile(cloudkitViewModel: CloudkitManagerViewModel, completion: @escaping (Bool) -> Void) {
        cloudkitViewModel.createProfessionalProfile(from: formData) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isProcessingPayment = false
                
                switch result {
                case .success:
                    self.alertMessage = "Professional registration successful! Your profile is now live."
                    self.showingAlert = true
                    completion(true)
                case .failure(let error):
                    self.alertMessage = "Registration failed: \(error.localizedDescription)"
                    self.showingAlert = true
                    completion(false)
                }
            }
        }
    }
}
