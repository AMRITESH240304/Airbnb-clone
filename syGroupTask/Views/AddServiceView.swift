import SwiftUI

struct AddServiceView: View {
    @Binding var services: [ProfessionalService]
    let availableCategories: [ServiceCategory]
    @Environment(\.dismiss) private var dismiss
    
    @State private var serviceName = ""
    @State private var serviceDescription = ""
    @State private var servicePrice = ""
    @State private var serviceDuration = ""
    @State private var selectedCategory: ServiceCategory = .realEstate
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                FormField(title: "Service Name", text: $serviceName, placeholder: "e.g., Property Consultation")
                
                FormField(title: "Description", text: $serviceDescription, placeholder: "Describe your service", axis: .vertical)
                
                FormField(title: "Price (₹)", text: $servicePrice, placeholder: "Enter price")
                
                FormField(title: "Duration", text: $serviceDuration, placeholder: "e.g., 1 hour, 2 days")
                
                VStack(alignment: .leading) {
                    Text("Category")
                        .font(.headline)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(availableCategories.isEmpty ? ServiceCategory.allCases : availableCategories) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addService()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !serviceName.isEmpty &&
        !serviceDescription.isEmpty &&
        !servicePrice.isEmpty &&
        !serviceDuration.isEmpty &&
        Double(servicePrice) != nil
    }
    
    private func addService() {
        guard let price = Double(servicePrice) else { return }
        
        let newService = ProfessionalService(
            name: serviceName,
            description: serviceDescription,
            price: price,
            duration: serviceDuration,
            category: selectedCategory
        )
        
        services.append(newService)
        dismiss()
    }
}