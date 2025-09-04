import SwiftUI

struct RecentlyViewedHomesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button("Edit") {
                    // Edit functionality
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Title
            HStack {
                Text("Recently viewed homes")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Today Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Today")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        // Today's properties
                        ForEach(MockData.todayViewed) { property in
                            RecentPropertyCard(property: property)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    // Tuesday 2 September Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Tuesday 2 September")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        // Previous day's properties in grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(MockData.previousDayViewed) { property in
                                RecentPropertyCard(property: property, isGridLayout: true)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
}

struct RecentPropertyCard: View {
    let property: RecentlyViewedProperty
    var isGridLayout: Bool = false
    @State private var isLiked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image with heart button
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: property.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: isGridLayout ? 140 : 180)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    isLiked.toggle()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isLiked ? .red : .white)
                        .frame(width: 28, height: 28)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // Property Details
            VStack(alignment: .leading, spacing: 4) {
                Text(property.title)
                    .font(.system(size: isGridLayout ? 14 : 16, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(property.details)
                        .font(.system(size: isGridLayout ? 12 : 14))
                        .foregroundColor(.gray)
                    
                    Text("★")
                        .font(.system(size: isGridLayout ? 12 : 14))
                        .foregroundColor(.black)
                    
                    Text(String(format: "%.2f", property.rating))
                        .font(.system(size: isGridLayout ? 12 : 14))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    RecentlyViewedHomesView()
}