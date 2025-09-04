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
            VStack(spacing: 20) {
                
                // Tabs
                HStack(spacing: 30) {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.title2)
                        Text("Homes")
                            .font(.caption)
                        Capsule()
                            .frame(height: 2)
                            .foregroundColor(.black)
                    }
                    
                    VStack {
                        Image(systemName: "balloon")
                            .font(.title2)
                        Text("Experiences")
                            .font(.caption)
                    }
                    
                    VStack {
                        Image(systemName: "bell")
                            .font(.title2)
                        Text("Services")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isSearching = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                // Search Field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search destinations", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.4)))
                .padding(.horizontal)
                
                // Recent searches
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent searches")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Promenade Beach").fontWeight(.semibold)
                            Text("5–7 Sept").font(.subheadline).foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text("Puducherry").fontWeight(.semibold)
                            Text("5–7 Sept").font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4, y: 2)
                .padding(.horizontal)
                
                // Suggested destinations
                VStack(alignment: .leading, spacing: 12) {
                    Text("Suggested destinations")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Nearby").fontWeight(.semibold)
                            Text("Find what’s around you").font(.subheadline).foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 4, y: 2)
                .padding(.horizontal)
                
                Spacer()
                
                // Footer buttons
                HStack {
                    Button("Clear all") {}
                        .foregroundColor(.black)
                    Spacer()
                    Button {
                        // search action
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}
