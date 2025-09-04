import SwiftUI

struct ServiceCardView: View {
    let service: ServiceItem
    
    var body: some View {
        VStack(spacing: 8) {
            // Service Image - use URL if available, fallback to local image
            if let imageURL = service.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(service.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Image(service.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Service Name
            Text(service.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.textPrimary)
            
            // Availability
            Text(service.availability)
                .font(.system(size: 14))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(width: 120)
    }
}

#Preview {
    ServiceCardView(service: ServiceItem(name: "Massage", availability: "1 available", imageName: "sample_room", imageURL: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c"))
}