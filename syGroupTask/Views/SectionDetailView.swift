import SwiftUI

struct SectionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let sectionTitle: String
    let cards: [CardModel]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                }
                
                Spacer()
                
                Button("Edit") {
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            HStack {
                Text(sectionTitle)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
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
                            CardsDetailView(cardId: card.id)
                                .toolbar(.hidden, for: .tabBar)
                        } label: {
                            CardsView(
                                flatName: card.flatName,
                                location: card.location,
                                cost: card.cost,
                                rating: card.rating,
                                label: card.label,
                                imageName: card.imageName,
                                imageURL: card.imageURL
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .background(Theme.background)
    }
}

#Preview {
    SectionDetailView(
        sectionTitle: "Available for similar dates",
        cards: MockData.availableForSimilarDates
    )
}
