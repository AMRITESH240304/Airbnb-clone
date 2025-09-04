import SwiftUI

struct DatePickerView: View {
    @Binding var selectedStartDate: Date?
    @Binding var selectedEndDate: Date?
    @Binding var dateSelectionMode: DateAndGuestSection.DateSelectionMode
    @Binding var flexibilityOption: DateAndGuestSection.FlexibilityOption
    @Binding var isPresented: Bool
    
    @StateObject private var viewModel = DatePickerViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // When? Header
                HStack {
                    Text("When?")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                
                // Mode Selection (Dates, Months, Flexible)
                HStack(spacing: 0) {
                    ForEach(DateAndGuestSection.DateSelectionMode.allCases, id: \.self) { mode in
                        Button(action: {
                            dateSelectionMode = mode
                        }) {
                            Text(mode.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(dateSelectionMode == mode ? Theme.textPrimary : Theme.textSecondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(dateSelectionMode == mode ? Theme.textLight : Color.clear)
                                )
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Content based on selected mode
                Group {
                    switch dateSelectionMode {
                    case .dates:
                        datesView
                    case .months:
                        monthsView
                    case .flexible:
                        flexibleView
                    }
                }
                
                Spacer()
                
                // Bottom Buttons
                HStack {
                    Button("Reset") {
                        viewModel.resetAllSelections()
                    }
                    .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Button("Next") {
                        // Sync back to parent bindings
                        selectedStartDate = viewModel.selectedStartDate
                        selectedEndDate = viewModel.selectedEndDate
                        isPresented = false
                    }
                    .foregroundColor(Theme.textLight)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Theme.textPrimary)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .onAppear {
                // Sync from parent bindings
                viewModel.selectedStartDate = selectedStartDate
                viewModel.selectedEndDate = selectedEndDate
            }
        }
    }
    
    // MARK: - Dates View
    private var datesView: some View {
        VStack {
            // Calendar View
            VStack {
                // Month Navigation
                HStack {
                    Button(action: { viewModel.previousMonth() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Theme.textPrimary)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.monthYearString)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: { viewModel.nextMonth() }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                .padding(.horizontal)
                
                // Weekday Headers
                HStack {
                    ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                        Text(day)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Theme.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                // Calendar Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                    ForEach(viewModel.calendarDays, id: \.self) { date in
                        if let date = date {
                            Button(action: {
                                viewModel.selectDate(date)
                            }) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(viewModel.dateTextColor(for: date))
                                    .frame(width: 40, height: 40)
                                    .background(viewModel.dateBackgroundColor(for: date))
                                    .clipShape(Circle())
                            }
                            .disabled(viewModel.isDateDisabled(date))
                        } else {
                            Text("")
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Flexibility Options
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(DateAndGuestSection.FlexibilityOption.allCases, id: \.self) { option in
                        Button(action: {
                            flexibilityOption = option
                        }) {
                            Text(option.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(flexibilityOption == option ? Theme.textLight : Theme.textPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(flexibilityOption == option ? Theme.textPrimary : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Theme.textSecondary, lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Months View
    private var monthsView: some View {
        VStack(spacing: 24) {
            // Month Duration Selector
            VStack(alignment: .leading, spacing: 16) {
                Text("Month(s)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                
                HStack {
                    Button(action: { viewModel.decreaseMonthDuration() }) {
                        Image(systemName: "minus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(Circle().stroke(Theme.textSecondary, lineWidth: 1))
                    }
                    
                    Spacer()
                    
                    Text("\(viewModel.monthDuration)")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { viewModel.increaseMonthDuration() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(Circle().stroke(Theme.textSecondary, lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // Starting date
            VStack(spacing: 16) {
                HStack {
                    Text("Starting date")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Button(action: {
                        // Could show another date picker
                    }) {
                        Text(viewModel.formatStartDate())
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                            .underline()
                    }
                }
                
                Divider()
                
                HStack {
                    Text("End date")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Button(action: {
                        // Could show another date picker
                    }) {
                        Text(viewModel.formatEndDate())
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                            .underline()
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Flexible View
    private var flexibleView: some View {
        VStack(spacing: 24) {
            // Stay Duration
            VStack(alignment: .leading, spacing: 16) {
                Text("How long would you like to stay?")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
                
                HStack(spacing: 12) {
                    ForEach(DatePickerViewModel.StayDuration.allCases, id: \.self) { duration in
                        Button(action: {
                            viewModel.selectStayDuration(duration)
                        }) {
                            Text(duration.rawValue)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(viewModel.stayDuration == duration ? Theme.textPrimary : Theme.textSecondary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(viewModel.stayDuration == duration ? Theme.textLight : Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Theme.textSecondary, lineWidth: 1)
                                        )
                                )
                        }
                    }
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            // Go anytime section
            VStack(alignment: .leading, spacing: 16) {
                Text("Go anytime")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.availableMonths, id: \.self) { month in
                            Button(action: {
                                viewModel.selectFlexibleMonth(month)
                            }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 32))
                                        .foregroundColor(Theme.textSecondary)
                                    
                                    Text(month)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Theme.textPrimary)
                                    
                                    Text("2025")
                                        .font(.system(size: 14))
                                        .foregroundColor(Theme.textSecondary)
                                }
                                .padding()
                                .frame(width: 120, height: 120)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.textSecondary.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
    }
}