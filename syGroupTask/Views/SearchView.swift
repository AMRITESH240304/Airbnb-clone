//
//  SearchView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 03/09/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var isSearching: Bool
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Top section with close button
                HStack {
                    Spacer()
                    Button(action: {
                        isSearching = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Main content card
                VStack(spacing: 20) {
                    
                    // Where? section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Where?")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                        }
                        
                        // Search Field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Theme.textSecondary)
                                .font(.system(size: 18))
                            TextField("Search destinations", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.system(size: 16))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    }
                    
                    // Recent searches
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recent searches")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                        }
                        
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Theme.textSecondary)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Promenade Beach")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Theme.textPrimary)
                                    Text("5–7 Sept")
                                        .font(.system(size: 14))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                Spacer()
                            }
                            
                            HStack(spacing: 12) {
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.green)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Puducherry")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Theme.textPrimary)
                                    Text("5–7 Sept")
                                        .font(.system(size: 14))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    // Suggested destinations
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Suggested destinations")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Nearby")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Theme.textPrimary)
                                Text("Find what's around you")
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            Spacer()
                        }
                        
                        // Additional location option
                        HStack(spacing: 12) {
                            Spacer()
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Puducherry, Puducherry")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Theme.textPrimary)
                            }
                            Spacer()
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
                .background(Theme.background)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                Spacer()
                
                // When and Who sections
                VStack(spacing: 12) {
                    // When section
                    HStack {
                        Text("When")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                        Spacer()
                        Text("Add dates")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding()
                    .background(Theme.background)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    // Who section
                    HStack {
                        Text("Who")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                        Spacer()
                        Text("Add guests")
                            .font(.system(size: 16))
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding()
                    .background(Theme.background)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Footer buttons
                HStack {
                    Button("Clear all") {
                        searchText = ""
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                    .underline()
                    
                    Spacer()
                    
                    Button {
                        // search action
                        isSearching = false
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .medium))
                            Text("Search")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(Theme.textLight)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Theme.primaryColor)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .background(Color.gray.opacity(0.1))
        }
    }
}

#Preview {
    SearchView(isSearching: .constant(true), searchText: .constant(""))
}
