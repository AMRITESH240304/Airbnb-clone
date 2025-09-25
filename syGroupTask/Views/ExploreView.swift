import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedFilter: String = "Real Estate"
    
    let filters = ["Real Estate", "Professionals", "Services"]

    var body: some View {
        ZStack {
            Theme.background
            VStack(spacing: 20) {
                
                // Search Bar
                Button {
                    isSearching = true
                } label: {
                    SearchBarView(searchText: $searchText, isSearching: $isSearching)
                        
                }
                .fullScreenCover(isPresented: $isSearching) {
                    SearchView(isSearching: $isSearching)
                }

                HStack(spacing: 24) {
                    ForEach(filters, id: \.self) { filter in
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedFilter = filter
                            }
                        } label: {
                            VStack {
                                Text(filter)
                                    .font(.system(size: 16, weight: selectedFilter == filter ? .bold : .regular))
                                    .foregroundColor(selectedFilter == filter ? Theme.textPrimary : Theme.textSecondary)
                                    .animation(.easeInOut(duration: 0.2), value: selectedFilter)
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedFilter == filter ? Theme.textPrimary : .clear)
                                    .animation(.easeInOut(duration: 0.3), value: selectedFilter)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Group {
                            if selectedFilter == "Real Estate" {
                                realEstateSection
                            } else if selectedFilter == "Professionals" {
                                experiencesSection
                            } else if selectedFilter == "Services" {
                                servicesSection
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .animation(.easeInOut(duration: 0.4), value: selectedFilter)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            cloudkitViewModel.fetchAllListings()
            cloudkitViewModel.fetchUserWishlist()
            cloudkitViewModel.fetchAllProfessionals()
            cloudkitViewModel.fetchAllCollaborations()
        }
    }

    var realEstateSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            let categorizedProperties = Dictionary(grouping: cloudkitViewModel.allProperties) { $0.category }
            
            if cloudkitViewModel.isLoading && cloudkitViewModel.allProperties.isEmpty {
                ProgressView("Loading properties...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if categorizedProperties.isEmpty {
                VStack(spacing: 16) {
                    Text("No properties available")
                        .foregroundColor(Theme.textSecondary)
                        .padding(.horizontal)
                    
                    if let errorMessage = cloudkitViewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    Button("Retry") {
                        cloudkitViewModel.fetchAllListings(forceRefresh: true)
                    }
                    .foregroundColor(Theme.primaryColor)
                }
            } else {
                ForEach(Array(categorizedProperties.keys).sorted(), id: \.self) { category in
                    if let properties = categorizedProperties[category], !properties.isEmpty {
                        CategorySectionView(
                            categoryName: category,
                            properties: properties
                        )
                    }
                }
            }
        }
    }

    var experiencesSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if cloudkitViewModel.isLoading && cloudkitViewModel.professionals.isEmpty {
                ProgressView("Loading professionals...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if cloudkitViewModel.professionals.isEmpty {
                VStack(spacing: 16) {
                    Text("No professionals available")
                        .foregroundColor(Theme.textSecondary)
                        .padding(.horizontal)
                    
                    Button("Refresh") {
                        cloudkitViewModel.fetchAllProfessionals(forceRefresh: true)
                    }
                    .foregroundColor(Theme.primaryColor)
                }
            } else {
                let categorizedProfessionals = Dictionary(grouping: cloudkitViewModel.professionals) { professional in
                    professional.categories.first?.rawValue ?? "Other"
                }
                
                ForEach(Array(categorizedProfessionals.keys).sorted(), id: \.self) { category in
                    if let professionals = categorizedProfessionals[category], !professionals.isEmpty {
                        ProfessionalCategorySectionView(
                            categoryName: category,
                            professionals: professionals
                        )
                    }
                }
            }
        }
    }
    
    var servicesSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if cloudkitViewModel.isLoading && cloudkitViewModel.collaborations.isEmpty {
                ProgressView("Loading collaborations...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if cloudkitViewModel.collaborations.isEmpty {
                VStack(spacing: 16) {
                    Text("No collaborations available")
                        .foregroundColor(Theme.textSecondary)
                        .padding(.horizontal)
                    
                    Button("Refresh") {
                        cloudkitViewModel.fetchAllCollaborations(forceRefresh: true)
                    }
                    .foregroundColor(Theme.primaryColor)
                }
            } else {
                let categorizedCollaborations = Dictionary(grouping: cloudkitViewModel.collaborations) { collaboration in
                    collaboration.collaborationType.rawValue
                }
                
                ForEach(Array(categorizedCollaborations.keys).sorted(), id: \.self) { category in
                    if let collaborations = categorizedCollaborations[category], !collaborations.isEmpty {
                        CollaborationCategorySectionView(
                            categoryName: category,
                            collaborations: collaborations
                        )
                    }
                }
            }
        }
    }
}

struct CategoryDetailView: View {
    let categoryName: String
    let properties: [PropertyListing]
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(properties) { property in
                    NavigationLink {
                        PropertyDetailView(property: property)
                    } label: {
                        PropertyListItemView(property: property)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(categoryName)
        .navigationBarTitleDisplayMode(.large)
    }
}
