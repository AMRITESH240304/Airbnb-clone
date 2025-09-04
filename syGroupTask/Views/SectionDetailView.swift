import SwiftUI

struct SectionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let sectionTitle: String
    let cards: [CardModel]
    
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
                Text(sectionTitle)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 16) {
                    ForEach(cards) { card in
                        NavigationLink {
                            CardsDetailView(number: card.id)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            SectionPropertyCard(card: card)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
}

struct SectionPropertyCard: View {
    let card: CardModel
    @State private var isLiked: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image with heart button and label
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    Image(card.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Label
                    Text(card.label)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(8)
                }
                
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
                Text(card.flatName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(card.cost)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text("★")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                    
                    Text(String(format: "%.2f", card.rating))
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    SectionDetailView(
        sectionTitle: "Available for similar dates",
        cards: MockData.availableForSimilarDates
    )
}