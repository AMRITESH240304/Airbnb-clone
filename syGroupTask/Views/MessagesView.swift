//
//  MessagesView.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var authViewModel: AuthManagerViewModel
    @EnvironmentObject var cloudkitViewModel: CloudkitManagerViewModel
    @State private var selectedFilter: String = "All"
    @State private var showLoginView = false
    let filters = ["All", "My Bookings", "Property Bookings", "Messages", "Support"]
    
    var body: some View {
        NavigationStack {
            if authViewModel.isAuthenticated {
                authenticatedMessagesView
            } else {
                NotLoginView(
                    screen: "Log in to view your messages and bookings",
                    tittle: "Messages and booking confirmations will appear here."
                )
                .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginSignUpView()
        }
        .onAppear {
            if authViewModel.isAuthenticated {
                cloudkitViewModel.fetchUserPayments(forceRefresh: true)
                cloudkitViewModel.fetchAllPayments() // Fetch all payments to see property bookings
            }
        }
    }
    
    private var authenticatedMessagesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("Inbox")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18))
                            .foregroundColor(Theme.textPrimary)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18))
                            .foregroundColor(Theme.textPrimary)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Filter Chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            HStack(spacing: 4) {
                                Text(filter)
                                    .font(.system(size: 16, weight: .medium))
                                
                                // Show badge count for bookings
                                if (filter == "My Bookings" && !userBookings.isEmpty) ||
                                   (filter == "Property Bookings" && !propertyBookings.isEmpty) {
                                    Text("\(filter == "My Bookings" ? userBookings.count : propertyBookings.count)")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Theme.primaryColor)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                selectedFilter == filter
                                ? Theme.textPrimary
                                : Color(.systemGray6)
                            )
                            .foregroundColor(
                                selectedFilter == filter
                                ? Theme.textLight
                                : Theme.textPrimary
                            )
                            .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Content based on selected filter
            ScrollView {
                LazyVStack(spacing: 16) {
                    if selectedFilter == "All" || selectedFilter == "My Bookings" {
                        myBookingsSection
                    }
                    
                    if selectedFilter == "All" || selectedFilter == "Property Bookings" {
                        propertyBookingsSection
                    }
                    
                    if selectedFilter == "All" || selectedFilter == "Messages" {
                        messagesSection
                    }
                    
                    if selectedFilter == "All" || selectedFilter == "Support" {
                        supportSection
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var myBookingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !userBookings.isEmpty {
                if selectedFilter == "All" {
                    HStack {
                        Text("My Bookings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Spacer()
                        
                        Button("See all") {
                            selectedFilter = "My Bookings"
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.primaryColor)
                    }
                }
                
                ForEach(displayedUserBookings) { payment in
                    BookingCardView(payment: payment, isOwnerView: false)
                }
            } else if selectedFilter == "My Bookings" {
                emptyMyBookingsView
            }
        }
    }
    
    private var propertyBookingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !propertyBookings.isEmpty {
                if selectedFilter == "All" {
                    HStack {
                        Text("Property Bookings")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Spacer()
                        
                        Button("See all") {
                            selectedFilter = "Property Bookings"
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.primaryColor)
                    }
                }
                
                ForEach(displayedPropertyBookings) { payment in
                    BookingCardView(payment: payment, isOwnerView: true)
                }
            } else if selectedFilter == "Property Bookings" {
                emptyPropertyBookingsView
            }
        }
    }
    
    private var messagesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if selectedFilter == "All" {
                HStack {
                    Text("Messages")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                }
            }
            
            // Empty messages for now
            if selectedFilter == "Messages" {
                emptyMessagesView
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if selectedFilter == "All" {
                HStack {
                    Text("Support")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    Spacer()
                }
            }
            
            // Empty support for now
            if selectedFilter == "Support" {
                emptySupportView
            }
        }
    }
    
    private var emptyMyBookingsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No bookings yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text("When you book a property, your booking details will appear here.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 40)
    }
    
    private var emptyPropertyBookingsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "house.badge.clock")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No property bookings")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text("When someone books your properties, their booking details will appear here.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 40)
    }
    
    private var emptyMessagesView: some View {
        VStack(spacing: 16) {
            Image(systemName: "message")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No messages")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Messages from property owners will appear here.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 40)
    }
    
    private var emptySupportView: some View {
        VStack(spacing: 16) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("No support messages")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Theme.textPrimary)
            
            Text("Support messages and help responses will appear here.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 40)
    }
    
    // Computed properties for filtering bookings
    private var userBookings: [Payment] {
        cloudkitViewModel.userPayments.filter { payment in
            payment.paymentType == .propertyContact && 
            payment.paymentStatus == .completed &&
            (payment.bookingStartDate != nil && payment.bookingEndDate != nil)
        }
    }
    
    private var propertyBookings: [Payment] {
        guard let currentUserID = cloudkitViewModel.cachedUserID else { return [] }
        
        return cloudkitViewModel.allPayments.filter { payment in
            payment.paymentType == .propertyContact &&
            payment.paymentStatus == .completed &&
            payment.recipientID == currentUserID &&
            (payment.bookingStartDate != nil && payment.bookingEndDate != nil)
        }
    }
    
    private var displayedUserBookings: [Payment] {
        if selectedFilter == "All" {
            return Array(userBookings.prefix(3)) // Show only first 3 in "All" view
        } else {
            return userBookings
        }
    }
    
    private var displayedPropertyBookings: [Payment] {
        if selectedFilter == "All" {
            return Array(propertyBookings.prefix(3)) // Show only first 3 in "All" view
        } else {
            return propertyBookings
        }
    }
}

struct BookingCardView: View {
    let payment: Payment
    let isOwnerView: Bool // True when showing bookings for property owner
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(payment.propertyTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(2)
                    
                    Text(payment.propertyLocation)
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                    
                    // Show booker info for property owners
                    if isOwnerView {
                        Text("Booked by: \(payment.payerName)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Theme.primaryColor)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(bookingStatusText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(bookingStatusColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(bookingStatusColor.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    Text("₹\(Int(payment.amount))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                    
                    if isOwnerView {
                        Text("Earned: ₹\(Int(payment.netAmount))")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                    }
                }
            }
            
            Divider()
            
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Check-in")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(formatDate(payment.bookingStartDate))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.minus")
                        .font(.system(size: 14))
                        .foregroundColor(Theme.textSecondary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Check-out")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textSecondary)
                        
                        Text(formatDate(payment.bookingEndDate))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Theme.textPrimary)
                    }
                }
                
                Spacer()
            }
            
            HStack {
                Text("Booking ID: \(payment.id.uuidString.prefix(8))")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                Text("Booked on \(formatDate(payment.transactionDate))")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var bookingStatusText: String {
        guard let startDate = payment.bookingStartDate,
              let endDate = payment.bookingEndDate else {
            return "Confirmed"
        }
        
        let now = Date()
        
        if now < startDate {
            return "Upcoming"
        } else if now >= startDate && now <= endDate {
            return "Current"
        } else {
            return "Completed"
        }
    }
    
    private var bookingStatusColor: Color {
        switch bookingStatusText {
        case "Upcoming":
            return .blue
        case "Current":
            return .green
        case "Completed":
            return .gray
        default:
            return Theme.primaryColor
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    MessagesView()
        .environmentObject(AuthManagerViewModel())
        .environmentObject(CloudkitManagerViewModel())
}
