//
//  DateAndGuestSectionView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 05/09/25.
//

import SwiftUI

struct DateAndGuestSection: View {
    @State private var showingDatePicker = false
    @State private var selectedStartDate: Date?
    @State private var selectedEndDate: Date?
    @State private var dateSelectionMode: DateSelectionMode = .dates
    @State private var flexibilityOption: FlexibilityOption = .exactDates

    enum DateSelectionMode: String, CaseIterable {
        case dates = "Dates"
        case months = "Months"
        case flexible = "Flexible"
    }

    enum FlexibilityOption: String, CaseIterable {
        case exactDates = "Exact dates"
        case plusOneDay = "± 1 day"
        case plusTwoDays = "± 2 days"
        case plusThreeDays = "± 3 days"
    }

    var body: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingDatePicker = true
            }) {
                HStack {
                    Text("When")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Text(dateButtonText)
                        .font(.system(size: 16))
                        .foregroundColor(
                            selectedStartDate != nil
                                ? Theme.textPrimary : Theme.textSecondary
                        )
                }
                .padding()
                .background(Theme.background)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerView(
                    selectedStartDate: $selectedStartDate,
                    selectedEndDate: $selectedEndDate,
                    dateSelectionMode: $dateSelectionMode,
                    flexibilityOption: $flexibilityOption,
                    isPresented: $showingDatePicker
                )
            }

            HStack {
                Text("Who")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("Add guests")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
            .background(Theme.background)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 16)
    }

    private var dateButtonText: String {
        if let startDate = selectedStartDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"

            if let endDate = selectedEndDate {
                return
                    "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
            } else {
                return formatter.string(from: startDate)
            }
        } else {
            return "Add dates"
        }
    }
}
