//
//  ExploreView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var selectedFilter: String = "Homes"
    
    let filters = ["Homes", "Experience", "Services"]

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
                    SearchView(
                        isSearching: $isSearching,
                        searchText: $searchText
                    )
                }

                // Top Filter Tabs
                HStack(spacing: 24) {
                    ForEach(filters, id: \.self) { filter in
                        Button {
                            selectedFilter = filter
                        } label: {
                            VStack {
                                Text(filter)
                                    .font(.system(size: 16, weight: selectedFilter == filter ? .bold : .regular))
                                    .foregroundColor(selectedFilter == filter ? Theme.textPrimary : Theme.textSecondary)
                                
                                // Small indicator for selected tab
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
                        if selectedFilter == "Homes" {
                            homesSection
                        } else if selectedFilter == "Experience" {  // Changed from "Experiences" to "Experience"
                            experiencesSection
                        } else if selectedFilter == "Services" {
                            servicesSection
                        }
                    }
                }
                
                Spacer()
            }
        }
    }

    // MARK: - Different Sections
    var homesSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Recently viewed homes section
            VStack(alignment: .leading) {
                NavigationLink {
                    RecentlyViewedHomesView()
                        .toolbar(.hidden, for: .tabBar)
                } label: {
                    HStack {
                        Text("Recently viewed homes")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MockData.sampleCards) { card in
                            NavigationLink {
                                CardsDetailView(number: card.id)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                CardsView(
                                    flatName: card.flatName,
                                    cost: card.cost,
                                    rating: card.rating,
                                    label: card.label,
                                    imageName: card.imageName
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Available for similar dates section
            VStack(alignment: .leading) {
                NavigationLink {
                    SectionDetailView(
                        sectionTitle: "Available for similar dates",
                        cards: MockData.availableForSimilarDates
                    )
                    .toolbar(.hidden, for: .tabBar)
                } label: {
                    HStack {
                        Text("Available for similar dates")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MockData.availableForSimilarDates) { card in
                            NavigationLink {
                                CardsDetailView(number: card.id)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                CardsView(
                                    flatName: card.flatName,
                                    cost: card.cost,
                                    rating: card.rating,
                                    label: card.label,
                                    imageName: card.imageName
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Stay in Puducherry section
            VStack(alignment: .leading) {
                NavigationLink {
                    SectionDetailView(
                        sectionTitle: "Stay in Puducherry",
                        cards: MockData.stayInPuducherry
                    )
                    .toolbar(.hidden, for: .tabBar)
                } label: {
                    HStack {
                        Text("Stay in Puducherry")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MockData.stayInPuducherry) { card in
                            NavigationLink {
                                CardsDetailView(number: card.id)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                CardsView(
                                    flatName: card.flatName,
                                    cost: card.cost,
                                    rating: card.rating,
                                    label: card.label,
                                    imageName: card.imageName
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Stay in Paris section
            VStack(alignment: .leading) {
                NavigationLink {
                    SectionDetailView(
                        sectionTitle: "Stay in Paris",
                        cards: MockData.stayInParis
                    )
                    .toolbar(.hidden, for: .tabBar)
                } label: {
                    HStack {
                        Text("Stay in Paris")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MockData.stayInParis) { card in
                            NavigationLink {
                                CardsDetailView(number: card.id)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                CardsView(
                                    flatName: card.flatName,
                                    cost: card.cost,
                                    rating: card.rating,
                                    label: card.label,
                                    imageName: card.imageName
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    var experiencesSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Airbnb Originals section
            VStack(alignment: .leading) {
                NavigationLink {
                    SectionDetailView(
                        sectionTitle: "Airbnb Originals",
                        cards: MockData.airbnbOriginals
                    )
                    .toolbar(.hidden, for: .tabBar)
                } label: {
                    HStack {
                        Text("Airbnb Originals")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MockData.airbnbOriginals) { experience in
                            NavigationLink {
                                CardsDetailView(number: experience.id)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                CardsView(
                                    flatName: experience.flatName,
                                    cost: experience.cost,
                                    rating: experience.rating,
                                    label: experience.label,
                                    imageName: experience.imageName
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Discover services on Airbnb - Photography section
            VStack(alignment: .leading, spacing: 16) {
                Text("Discover services on Airbnb")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    NavigationLink {
                        SectionDetailView(
                            sectionTitle: "Photography",
                            cards: MockData.photographyExperiences
                        )
                        .toolbar(.hidden, for: .tabBar)
                    } label: {
                        HStack {
                            Text("Photography")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Theme.textPrimary)
                                .lineLimit(1)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(MockData.photographyExperiences) { experience in
                                NavigationLink {
                                    CardsDetailView(number: experience.id)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    CardsView(
                                        flatName: experience.flatName,
                                        cost: experience.cost,
                                        rating: experience.rating,
                                        label: experience.label,
                                        imageName: experience.imageName
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            // All experiences in Promenade Beach section
            VStack(alignment: .leading) {
                NavigationLink {
                    SectionDetailView(
                        sectionTitle: "All experiences in Promenade Beach",
                        cards: MockData.allExperiencesPondicherry
                    )
                    .toolbar(.hidden, for: .tabBar)
                } label: {
                    HStack {
                        Text("All experiences in Promenade Beach")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MockData.allExperiencesPondicherry) { experience in
                            NavigationLink {
                                CardsDetailView(number: experience.id)
                                    .toolbar(.hidden, for: .tabBar)
                            } label: {
                                CardsView(
                                    flatName: experience.flatName,
                                    cost: experience.cost,
                                    rating: experience.rating,
                                    label: experience.label,
                                    imageName: experience.imageName
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    var servicesSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Services in Promenade Beach section
            VStack(alignment: .leading, spacing: 16) {
                Text("Services in Promenade Beach")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(MockData.servicesInPromenadeBeach) { service in
                            Button {
                                // Handle service selection
                            } label: {
                                ServiceCardView(service: service)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Discover services on Airbnb section for Services tab
            VStack(alignment: .leading, spacing: 16) {
                Text("Discover services on Airbnb")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Photography")
                        .font(.system(size: 16, weight: .bold))
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(MockData.photographyExperiences) { experience in
                                NavigationLink {
                                    CardsDetailView(number: experience.id)
                                        .toolbar(.hidden, for: .tabBar)
                                } label: {
                                    CardsView(
                                        flatName: experience.flatName,
                                        cost: experience.cost,
                                        rating: experience.rating,
                                        label: experience.label,
                                        imageName: experience.imageName
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
