import SwiftUI
import Foundation

@MainActor
class DatePickerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedStartDate: Date?
    @Published var selectedEndDate: Date?
    @Published var currentMonth = Date()
    @Published var isSelectingEndDate = false
    @Published var stayDuration: StayDuration = .weekend
    @Published var monthDuration: Int = 2
    @Published var flexibleStartDate = Date()
    @Published var flexibleEndDate: Date
    
    // MARK: - Enums
    enum StayDuration: String, CaseIterable {
        case weekend = "Weekend"
        case week = "Week"
        case month = "Month"
    }
    
    // MARK: - Initializer
    init() {
        self.flexibleEndDate = Calendar.current.date(byAdding: .month, value: 2, to: Date()) ?? Date()
    }
    
    // MARK: - Date Selection Logic
    func selectDate(_ date: Date) {
        if selectedStartDate == nil || isSelectingEndDate {
            if selectedStartDate == nil {
                selectedStartDate = date
                isSelectingEndDate = true
            } else if let start = selectedStartDate, date >= start {
                selectedEndDate = date
                isSelectingEndDate = false
            } else {
                selectedStartDate = date
                selectedEndDate = nil
                isSelectingEndDate = true
            }
        } else {
            selectedStartDate = date
            selectedEndDate = nil
            isSelectingEndDate = true
        }
    }
    
    // MARK: - Date Styling Logic
    func dateTextColor(for date: Date) -> Color {
        if let start = selectedStartDate, let end = selectedEndDate {
            if date >= start && date <= end {
                return Theme.textLight
            }
        } else if let start = selectedStartDate, Calendar.current.isDate(date, inSameDayAs: start) {
            return Theme.textLight
        }
        
        if date < Date() {
            return Theme.textSecondary.opacity(0.3)
        }
        
        return Theme.textPrimary
    }
    
    func dateBackgroundColor(for date: Date) -> Color {
        if let start = selectedStartDate, let end = selectedEndDate {
            if date >= start && date <= end {
                return Theme.primaryColor
            }
        } else if let start = selectedStartDate, Calendar.current.isDate(date, inSameDayAs: start) {
            return Theme.primaryColor
        }
        
        return Color.clear
    }
    
    func isDateDisabled(_ date: Date) -> Bool {
        return date < Date()
    }
    
    // MARK: - Calendar Navigation
    func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    // MARK: - Month Duration Logic
    func decreaseMonthDuration() {
        if monthDuration > 1 {
            monthDuration -= 1
            updateDatesBasedOnMonthDuration()
        }
    }
    
    func increaseMonthDuration() {
        if monthDuration < 12 {
            monthDuration += 1
            updateDatesBasedOnMonthDuration()
        }
    }
    
    private func updateDatesBasedOnMonthDuration() {
        if let start = selectedStartDate {
            selectedEndDate = Calendar.current.date(byAdding: .month, value: monthDuration, to: start)
        }
    }
    
    // MARK: - Reset Logic
    func resetAllSelections() {
        selectedStartDate = nil
        selectedEndDate = nil
        isSelectingEndDate = false
        monthDuration = 2
        stayDuration = .weekend
        currentMonth = Date()
    }
    
    // MARK: - Computed Properties
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    var calendarDays: [Date?] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        
        let startOfCalendar = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        
        var days: [Date?] = []
        var date = startOfCalendar
        
        while days.count < 42 { // 6 weeks × 7 days
            if calendar.isDate(date, equalTo: currentMonth, toGranularity: .month) {
                days.append(date)
            } else {
                days.append(nil)
            }
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        return days
    }
    
    var availableMonths: [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        var months: [String] = []
        var currentDate = Date()
        
        for i in 0..<6 { 
            months.append(formatter.string(from: currentDate))
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
        }
        
        return months
    }
    
    // MARK: - Flexible Mode Logic
    func selectStayDuration(_ duration: StayDuration) {
        stayDuration = duration
    }
    
    func selectFlexibleMonth(_ month: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        if let date = formatter.date(from: "\(month) 2025") {
            selectedStartDate = date
            
            // Set end date based on stay duration
            switch stayDuration {
            case .weekend:
                selectedEndDate = Calendar.current.date(byAdding: .day, value: 2, to: date)
            case .week:
                selectedEndDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date)
            case .month:
                selectedEndDate = Calendar.current.date(byAdding: .month, value: 1, to: date)
            }
        }
    }
    
    // MARK: - Date Formatting
    func formatStartDate() -> String {
        guard let startDate = selectedStartDate else { return "Wed, 1 Oct" }
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter.string(from: startDate)
    }
    
    func formatEndDate() -> String {
        guard let endDate = selectedEndDate else { return "Mon, 1 Dec" }
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter.string(from: endDate)
    }
    
    // MARK: - Validation
    var hasValidDateSelection: Bool {
        return selectedStartDate != nil
    }
    
    var dateRangeText: String {
        if let startDate = selectedStartDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            
            if let endDate = selectedEndDate {
                return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
            } else {
                return formatter.string(from: startDate)
            }
        } else {
            return "Add dates"
        }
    }
}
