import SwiftUI
import Charts

struct TransactionHistoryView: View {
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter: TransactionFilter = .all
    @State private var chartAnimationProgress: CGFloat = 0.0 // State for chart animation
    
    var body: some View {
        NavigationView {
            VStack {
                // Payment Trend Chart
                paymentTrendChart
                
                // Filter Picker
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TransactionFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Transaction List
                List {
                    ForEach(filteredPayments) { payment in
                        TransactionRow(payment: payment)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Transaction History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            cloudkitViewModel.fetchAllPayments()
            withAnimation(.easeOut(duration: 1.0)) {
                chartAnimationProgress = 1.0 // Trigger chart animation
            }
        }
    }
    
    private var paymentTrendChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Trend")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if !filteredPayments.isEmpty {
                Chart(filteredPayments) { payment in
                    LineMark(
                        x: .value("Date", payment.transactionDate),
                        y: .value("Amount", chartAnimationProgress * payment.amount)
                    )
                    .foregroundStyle(Theme.primaryColor)
                }
                .frame(height: 200)
                .padding(.horizontal)
            } else {
                Text("No payment data available")
                    .foregroundColor(Theme.textSecondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var filteredPayments: [Payment] {
        let allPayments = cloudkitViewModel.getAllPayments()
        
        switch selectedFilter {
        case .all:
            return allPayments
        case .received:
            return allPayments.filter { $0.recipientID == cloudkitViewModel.cachedUserID }
        case .sent:
            return allPayments.filter { $0.payerID == cloudkitViewModel.cachedUserID }
        case .thisMonth:
            let calendar = Calendar.current
            let now = Date()
            return allPayments.filter { payment in
                calendar.isDate(payment.transactionDate, equalTo: now, toGranularity: .month)
            }
        }
    }
}

struct TransactionRow: View {
    let payment: Payment
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.propertyTitle)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(payment.description)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(2)
                
                HStack {
                    Text(payment.paymentType.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Theme.primaryColor.opacity(0.1))
                        .foregroundColor(Theme.primaryColor)
                        .cornerRadius(6)
                    
                    Text(formatDate(payment.transactionDate))
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(isReceived ? "+₹\(Int(payment.netAmount))" : "-₹\(Int(payment.amount))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isReceived ? .green : .red)
                
                Text(payment.paymentStatus.rawValue)
                    .font(.caption)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var isReceived: Bool {
        payment.recipientID == cloudkitViewModel.cachedUserID
    }
    
    private var statusColor: Color {
        switch payment.paymentStatus {
        case .completed:
            return .green
        case .pending, .processing:
            return .orange
        case .failed, .cancelled:
            return .red
        case .refunded:
            return .blue
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

enum TransactionFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case received = "Received"
    case sent = "Sent"
    case thisMonth = "This Month"
    
    var id: String { self.rawValue }
}