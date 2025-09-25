//
//  ProfessionalDetailView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 26/09/25.
//

import SwiftUI

struct ProfessionalDetailView: View {
    let professional: Professional
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var showingContactSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        AsyncImage(url: URL(string: professional.profileImageURL ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Theme.primaryColor.opacity(0.2))
                                .overlay(
                                    Text(String(professional.businessName.prefix(1)))
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Theme.primaryColor)
                                )
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(professional.businessName)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                if professional.isVerified {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                
                                Text(String(format: "%.1f", professional.rating))
                                    .fontWeight(.medium)
                                
                                Text("(\(professional.reviewCount) reviews)")
                                    .foregroundColor(Theme.textSecondary)
                            }
                            
                            Text(professional.location)
                                .foregroundColor(Theme.textSecondary)
                            
                            Text("\(professional.experience) years experience")
                                .font(.subheadline)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.primaryColor.opacity(0.1))
                                .foregroundColor(Theme.primaryColor)
                                .cornerRadius(6)
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Services")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    ForEach(professional.services) { service in
                        ServiceRow(service: service)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                Button(action: {
                    showingContactSheet = true
                }) {
                    HStack {
                        if isOwnProfessionalProfile() {
                            Image(systemName: "eye.fill")
                                .foregroundColor(.white)
                            Text("View My Profile")
                        } else if cloudkitViewModel.hasUserPaidForProfessionalContact(professional: professional) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                            Text("Contact Professional")
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
                        isOwnProfessionalProfile() ? Color.blue :
                        cloudkitViewModel.hasUserPaidForProfessionalContact(professional: professional) ? Color.green :
                        Theme.primaryColor
                    )
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Professional Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContactSheet) {
            ProfessionalContactSheet(professional: professional)
        }
    }
    
    private func isOwnProfessionalProfile() -> Bool {
        return cloudkitViewModel.cachedUserID == professional.userID
    }
}
