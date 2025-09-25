//
//  CollaborationDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct CollaborationDetailView: View {
    let collaboration: Collaboration
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var showingContactSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
