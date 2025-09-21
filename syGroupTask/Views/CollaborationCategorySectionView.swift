import SwiftUI

struct CollaborationCategorySectionView: View {
    let categoryName: String
    let collaborations: [Collaboration]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(categoryName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                NavigationLink(destination: CollaborationCategoryDetailView(
                    categoryName: categoryName,
                    collaborations: collaborations
                )) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(Theme.primaryColor)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(collaborations.prefix(5)) { collaboration in
                        NavigationLink(destination: CollaborationDetailView(collaboration: collaboration)) {
                            CollaborationCard(collaboration: collaboration)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CollaborationCard: View {
    let collaboration: Collaboration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Business Logo
            AsyncImage(url: URL(string: collaboration.logoImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "building.2")
                            .foregroundColor(.gray)
                            .font(.title2)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(collaboration.businessName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                
                Text(collaboration.businessType.rawValue)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(Theme.primaryColor)
                        .font(.caption)
                    Text(collaboration.location)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                }
                
                Text(collaboration.investmentRange.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.primaryColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.primaryColor.opacity(0.1))
                    .cornerRadius(8)
                
                HStack {
                    if collaboration.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                    if collaboration.isPremium {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", collaboration.rating))
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
        }
        .padding()
        .frame(width: 220)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct CollaborationCategoryDetailView: View {
    let categoryName: String
    let collaborations: [Collaboration]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(collaborations) { collaboration in
                    NavigationLink(destination: CollaborationDetailView(collaboration: collaboration)) {
                        CollaborationListCard(collaboration: collaboration)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CollaborationListCard: View {
    let collaboration: Collaboration
    
    var body: some View {
        HStack(spacing: 16) {
            // Business Logo
            AsyncImage(url: URL(string: collaboration.logoImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "building.2")
                            .foregroundColor(.gray)
                            .font(.title2)
                    )
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(collaboration.businessName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    HStack {
                        if collaboration.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .font(.caption)
                        }
                        if collaboration.isPremium {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                    }
                }
                
                Text(collaboration.businessType.rawValue)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(Theme.primaryColor)
                        .font(.caption)
                    Text(collaboration.location)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                }
                
                HStack {
                    Text(collaboration.investmentRange.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.primaryColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.primaryColor.opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", collaboration.rating))
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                        Text("(\(collaboration.reviewCount))")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                Text(collaboration.description)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct CollaborationDetailView: View {
    let collaboration: Collaboration
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var showingContactSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Business Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        AsyncImage(url: URL(string: collaboration.logoImageURL ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray5))
                                .overlay(
                                    Image(systemName: "building.2")
                                        .foregroundColor(.gray)
                                        .font(.title)
                                )
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(collaboration.businessName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            
                            Text(collaboration.businessType.rawValue)
                                .font(.subheadline)
                                .foregroundColor(Theme.textSecondary)
                            
                            HStack {
                                if collaboration.isVerified {
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.blue)
                                        Text("Verified")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                                
                                if collaboration.isPremium {
                                    HStack(spacing: 4) {
                                        Image(systemName: "crown.fill")
                                            .foregroundColor(.orange)
                                        Text("Premium")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // Rating and location
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", collaboration.rating))
                                .fontWeight(.medium)
                            Text("(\(collaboration.reviewCount) reviews)")
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .foregroundColor(Theme.primaryColor)
                            Text(collaboration.location)
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .font(.subheadline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Collaboration Details
                VStack(alignment: .leading, spacing: 16) {
                    Text("Collaboration Details")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    CollaborationDetailRow(title: "Type", value: collaboration.collaborationType.rawValue)
                    CollaborationDetailRow(title: "Investment Range", value: collaboration.investmentRange.rawValue)
                    CollaborationDetailRow(title: "Expected ROI", value: collaboration.expectedROI)
                    CollaborationDetailRow(title: "Experience Required", value: collaboration.experienceRequired)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Business Description
                VStack(alignment: .leading, spacing: 12) {
                    Text("About")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(collaboration.description)
                        .font(.body)
                        .foregroundColor(Theme.textSecondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Business Model
                VStack(alignment: .leading, spacing: 12) {
                    Text("Business Model")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(collaboration.businessModel)
                        .font(.body)
                        .foregroundColor(Theme.textSecondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Support Provided
                if !collaboration.supportProvided.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Support Provided")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(collaboration.supportProvided, id: \.self) { support in
                                Text(support)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Theme.primaryColor.opacity(0.1))
                                    .foregroundColor(Theme.primaryColor)
                                    .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                
                // Contact Button
                Button(action: {
                    showingContactSheet = true
                }) {
                    HStack {
                        if isOwnCollaboration() {
                            Image(systemName: "eye.fill")
                                .foregroundColor(.white)
                            Text("View My Collaboration")
                        } else if cloudkitViewModel.hasUserPaidForCollaborationContact(collaboration: collaboration) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                            Text("Contact Business")
                        } else {
                            Image(systemName: "indianrupeesign.circle")
                                .foregroundColor(.white)
                            Text("Pay to Contact")
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        isOwnCollaboration() ? Color.blue :
                        cloudkitViewModel.hasUserPaidForCollaborationContact(collaboration: collaboration) ? Color.green : 
                        Theme.primaryColor
                    )
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Collaboration Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContactSheet) {
            CollaborationContactSheet(collaboration: collaboration)
        }
    }
    
    private func isOwnCollaboration() -> Bool {
        return cloudkitViewModel.cachedUserID == collaboration.userID
    }
}

struct CollaborationDetailRow: View {
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
                
                // Check if this is user's own collaboration
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
                        
                        // Show contact information directly since it's their own collaboration
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
                    // Show contact information for paid users
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
                    // Show payment required section for other users
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