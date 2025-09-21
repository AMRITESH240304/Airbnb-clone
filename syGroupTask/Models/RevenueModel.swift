import Foundation

struct RevenueData {
    var totalAmount: Double = 0
    var totalPlatformFee: Double = 0
    var paymentCount: Int = 0
    var propertyCount: Int = 0
    var propertyRevenue: [PropertyRevenueData] = []
    var typeRevenue: [TypeRevenueData] = []
    var monthlyData: [MonthlyRevenueData] = []
}

struct PropertyRevenueData: Identifiable {
    let id = UUID()
    let propertyID: UUID
    let propertyTitle: String
    let propertyLocation: String
    let revenue: Double
    let contactCount: Int
}

struct TypeRevenueData: Identifiable {
    let id = UUID()
    let type: String
    let revenue: Double
}

struct MonthlyRevenueData: Identifiable {
    let id = UUID()
    let month: Date
    let revenue: Double
}