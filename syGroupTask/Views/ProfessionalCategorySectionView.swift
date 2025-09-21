import SwiftUI

struct ProfessionalCategorySectionView: View {
    let categoryName: String
    let professionals: [Professional]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(categoryName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                NavigationLink(destination: ProfessionalCategoryDetailView(categoryName: categoryName, professionals: professionals)) {
                    Text("See all")
                        .font(.subheadline)
                        .foregroundColor(Theme.primaryColor)
                        .fontWeight(.medium)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(professionals.prefix(5)) { professional in
                        NavigationLink(destination: ProfessionalDetailView(professional: professional)) {
                            ProfessionalCard(professional: professional)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProfessionalCard: View {
    let professional: Professional
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Profile Image
            AsyncImage(url: URL(string: professional.profileImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Theme.primaryColor.opacity(0.2))
                    .overlay(
                        Text(String(professional.businessName.prefix(1)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(professional.businessName)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text(professional.location)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", professional.rating))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Text("(\(professional.reviewCount))")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                    
                    if professional.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                
                Text("₹\(Int(professional.services.first?.price ?? 0))+")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.primaryColor)
            }
        }
        .padding()
        .frame(width: 200)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct ProfessionalCategoryDetailView: View {
    let categoryName: String
    let professionals: [Professional]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(professionals) { professional in
                    NavigationLink(destination: ProfessionalDetailView(professional: professional)) {
                        ProfessionalListCard(professional: professional)
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

struct ProfessionalListCard: View {
    let professional: Professional
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image
            AsyncImage(url: URL(string: professional.profileImageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Theme.primaryColor.opacity(0.2))
                    .overlay(
                        Text(String(professional.businessName.prefix(1)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                    )
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(professional.businessName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if professional.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                Text(professional.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(Theme.textSecondary)
                        .font(.caption)
                    
                    Text(professional.location)
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        
                        Text(String(format: "%.1f", professional.rating))
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text("(\(professional.reviewCount))")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                
                HStack {
                    Text("\(professional.experience) years experience")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.primaryColor.opacity(0.1))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Text("From ₹\(Int(professional.services.min(by: { $0.price < $1.price })?.price ?? 0))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.primaryColor)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct ProfessionalDetailView: View {
    let professional: Professional
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var showingContactSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
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
                
                // Description
                VStack(alignment: .leading, spacing: 12) {
                    Text("About")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(professional.description)
                        .foregroundColor(Theme.textSecondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Services
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
                
                // Contact Button
                Button(action: {
                    showingContactSheet = true
                }) {
                    Text("Contact Professional")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.primaryColor)
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
}

struct ServiceRow: View {
    let service: ProfessionalService
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(service.name)
                    .font(.headline)
                
                Text(service.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                
                Text(service.duration)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Text("₹\(Int(service.price))")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryColor)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ProfessionalContactSheet: View {
    let professional: Professional
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Contact Information")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    ContactInfoRow(icon: "phone.fill", title: "Phone", value: professional.phoneNumber)
                    ContactInfoRow(icon: "envelope.fill", title: "Email", value: professional.email)
                    
                    if let website = professional.website {
                        ContactInfoRow(icon: "globe", title: "Website", value: website)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
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
    }
}

struct ContactInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Theme.primaryColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
    }
}