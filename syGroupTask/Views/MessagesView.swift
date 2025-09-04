//
//  MessagesView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct MessagesView: View {
    @State private var selectedFilter: String = "All"
    let filters = ["All", "Travelling", "Support"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("Messages")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            Text(filter)
                                .font(.system(size: 16, weight: .medium))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    selectedFilter == filter
                                    ? Color.black
                                    : Color(.systemGray6)
                                )
                                .foregroundColor(
                                    selectedFilter == filter
                                    ? .white
                                    : .black
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Empty State
            VStack(spacing: 8) {
                Image(systemName: "message")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                
                Text("You don’t have any messages")
                    .font(.system(size: 16, weight: .semibold))
                
                Text("When you receive a new message, it will appear here.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
    }
}

#Preview {
    MessagesView()
}
