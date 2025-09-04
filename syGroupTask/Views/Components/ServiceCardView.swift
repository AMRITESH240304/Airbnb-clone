import SwiftUI

struct ServiceCardView: View {
    let service: ServiceItem
    
    var body: some View {
        VStack(spacing: 8) {
            // Service Image
            Image(service.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Service Name
            Text(service.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            // Availability
            Text(service.availability)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(width: 120)
    }
}

#Preview {
    ServiceCardView(service: ServiceItem(name: "Massage", availability: "1 available", imageName: "sample_room"))
}