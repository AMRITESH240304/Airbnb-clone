//
//  CollaborationContactSheet.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct CollaborationContactSheet: View {
    let collaboration: Collaboration
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var isProcessingPayment = false
    @State private var showingPaymentAlert = false
    @State private var paymentMessage = ""
    @State private var paymentSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Contact Information")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                if isOwnCollaboration() {
                    VStack(spacing: 16) {
                        Image(systemName: "building.2.fill")
                            .font(.system(size: 50))
                            .foregroundColor(Theme.primaryColor)
                        
                        Text("This is Your Collaboration")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("You cannot view contact details for your own collaboration")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            ContactInfoRow(icon: "phone.fill", title: "Phone", value: collaboration.contactPhone)
                            ContactInfoRow(icon: "envelope.fill", title: "Email", value: collaboration.contactEmail)
                            
                            if let website = collaboration.website {
                                ContactInfoRow(icon: "globe", title: "Website", value: website)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }
                } else if cloudkitViewModel.hasUserPaidForCollaborationContact(collaboration: collaboration) {
                    VStack(alignment: .leading, spacing: 16) {
                        ContactInfoRow(icon: "phone.fill", title: "Phone", value: collaboration.contactPhone)
                        ContactInfoRow(icon: "envelope.fill", title: "Email", value: collaboration.contactEmail)
                        
                        if let website = collaboration.website {
                            ContactInfoRow(icon: "globe", title: "Website", value: website)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                } else {
                    VStack(spacing: 16) {
                        VStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            
                            Text("Contact Information Locked")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("Pay ₹\(Int(RevenueConfig.contactOwnerFee)) to unlock contact details for this collaboration")
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        
                        Button(action: {
                            processCollaborationContactPayment()
                        }) {
                            HStack {
                                if isProcessingPayment {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "indianrupeesign.circle")
                                        .foregroundColor(.white)
                                }
                                
                                Text(isProcessingPayment ? "Processing..." : "Pay ₹\(Int(RevenueConfig.contactOwnerFee)) to Contact")
                            }
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isProcessingPayment ? Color.gray : Theme.primaryColor)
                            .cornerRadius(12)
                        }
                        .disabled(isProcessingPayment)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .alert(paymentSuccess ? "Payment Successful!" : "Payment Info", isPresented: $showingPaymentAlert) {
            Button("OK") {
                if paymentSuccess {
                    cloudkitViewModel.fetchUserPayments(forceRefresh: true)
                }
            }
        } message: {
            Text(paymentMessage)
        }
        .onAppear {
            cloudkitViewModel.fetchUserPayments(forceRefresh: true)
        }
    }
    
    private func isOwnCollaboration() -> Bool {
        return cloudkitViewModel.cachedUserID == collaboration.userID
    }
    
    private func processCollaborationContactPayment() {
        isProcessingPayment = true
        
        cloudkitViewModel.processCollaborationContactPayment(collaboration: collaboration) { [self] result in
            DispatchQueue.main.async {
                self.isProcessingPayment = false
                
                switch result {
                case .success(_):
                    self.paymentMessage = "Payment successful! You can now view contact details."
                    self.paymentSuccess = true
                    self.showingPaymentAlert = true
                    
                case .failure(let error):
                    self.paymentMessage = "Payment failed: \(error.localizedDescription)"
                    self.paymentSuccess = false
                    self.showingPaymentAlert = true
                }
            }
        }
    }
}

