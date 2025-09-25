import SwiftUI
import Charts

struct IncomeAnalyticsView: View {
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeFrame: TimeFrame = .thisMonth
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Time Frame", selection: $selectedTimeFrame) {
                        ForEach(TimeFrame.allCases) { timeFrame in
                            Text(timeFrame.rawValue).tag(timeFrame)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    totalRevenueCard
                    
                    revenueByPropertyChart
                    
                    revenueByTypeChart
                    
                    monthlyTrendChart
                    
                    propertyPerformanceList
                }
                .padding()
            }
            .navigationTitle("Income Analytics")
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
            cloudkitViewModel.fetchUserRevenue()
        }
    }
    
    private var totalRevenueCard: some View {
        VStack(spacing: 12) {
            Text("Total Revenue")
                .font(.headline)
                .foregroundColor(Theme.textSecondary)
            
            Text("₹\(Int(filteredRevenue.totalAmount))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
            
            HStack(spacing: 20) {
                VStack {
                    Text("Payments")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text("\(filteredRevenue.paymentCount)")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                VStack {
                    Text("Properties")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text("\(filteredRevenue.propertyCount)")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                VStack {
                    Text("Platform Fee")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Text("₹\(Int(filteredRevenue.totalPlatformFee))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var revenueByPropertyChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Revenue by Property")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if !filteredRevenue.propertyRevenue.isEmpty {
                Chart(filteredRevenue.propertyRevenue) { item in
                    BarMark(
                        x: .value("Revenue", item.revenue),
                        y: .value("Property", item.propertyTitle)
                    )
                    .foregroundStyle(Theme.primaryColor)
                }
                .frame(height: 200)
                .padding(.horizontal)
            } else {
                Text("No revenue data available")
                    .foregroundColor(Theme.textSecondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var revenueByTypeChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Revenue by Type")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if !filteredRevenue.typeRevenue.isEmpty {
                Chart(filteredRevenue.typeRevenue) { item in
                    SectorMark(
                        angle: .value("Revenue", item.revenue),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(by: .value("Type", item.type))
                }
                .frame(height: 200)
                .padding(.horizontal)
            } else {
                Text("No revenue data available")
                    .foregroundColor(Theme.textSecondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var monthlyTrendChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Trend")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            if !filteredRevenue.monthlyData.isEmpty {
                Chart(filteredRevenue.monthlyData) { item in
                    LineMark(
                        x: .value("Month", item.month),
                        y: .value("Revenue", item.revenue)
                    )
                    .foregroundStyle(Theme.primaryColor)
                }
                .frame(height: 200)
                .padding(.horizontal)
            } else {
                Text("No monthly data available")
                    .foregroundColor(Theme.textSecondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var propertyPerformanceList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Property Performance")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ForEach(filteredRevenue.propertyRevenue) { property in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(property.propertyTitle)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text(property.propertyLocation)
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("₹\(Int(property.revenue))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.primaryColor)
                        
                        Text("\(property.contactCount) contacts")
                            .font(.caption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding(.vertical)
    }
    
    private var filteredRevenue: RevenueData {
        cloudkitViewModel.getFilteredRevenue(for: selectedTimeFrame)
    }
}

enum TimeFrame: String, CaseIterable, Identifiable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case last3Months = "Last 3 Months"
    case thisYear = "This Year"
    case allTime = "All Time"
    
    var id: String { self.rawValue }
}
