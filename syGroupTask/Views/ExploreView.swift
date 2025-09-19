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
                    SearchBarView(searchText: $searchText)
                }
                .fullScreenCover(isPresented: $isSearching) {
                    SearchView(isSearching: $isSearching)
                }

                HStack(spacing: 24) {
                    ForEach(filters, id: \.self) { filter in
                        Button {
                            selectedFilter = filter
                        } label: {
                            VStack {
                                Text(filter)
                                    .font(.system(size: 16, weight: selectedFilter == filter ? .bold : .regular))
                                    .foregroundColor(selectedFilter == filter ? Theme.textPrimary : Theme.textSecondary)
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedFilter == filter ? Theme.textPrimary : .clear)
                            }
                        }
                    }
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if selectedFilter == "Real Estate" {
                            realEstateSection
                        } else if selectedFilter == "Professionals" {
                            experiencesSection
                        } else if selectedFilter == "Services" {
                            servicesSection
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            cloudkitViewModel.fetchAllListings()
            print("All properties count: \(cloudkitViewModel.allProperties.count)")
        }
    }

    // MARK: - Real Estate Section (Dynamic)
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

    // MARK: - Other Sections (Keep existing implementation)
    var experiencesSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Professionals section - Coming soon")
                .foregroundColor(Theme.textSecondary)
                .padding(.horizontal)
        }
    }
    
    var servicesSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Services section - Coming soon")
                .foregroundColor(Theme.textSecondary)
                .padding(.horizontal)
        }
    }
}

struct CategoryDetailView: View {
    let categoryName: String
    let properties: [PropertyListing]
    
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
