import SwiftUI

struct CollaborationCategorySectionView: View {
    let categoryName: String
    let collaborations: [Collaboration]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(categoryName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                NavigationLink(destination: CollaborationCategoryDetailView(
                    categoryName: categoryName,
                    collaborations: collaborations
                )) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(Theme.primaryColor)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(collaborations.prefix(5)) { collaboration in
                        NavigationLink(destination: CollaborationDetailView(collaboration: collaboration)) {
                            CollaborationCard(collaboration: collaboration)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

