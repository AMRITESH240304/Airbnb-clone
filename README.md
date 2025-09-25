# RealEstate

**Conversion of Airbnb clone to a realEstate app with feature enhancement using cloudkit for data and the challenge to keep the UI same.**

<img src="appSs/PropertyListingPage.png" alt="Property Listing" width="300"/>

*Main property listing interface showing available real estate properties*

## 🏗️ Architecture Overview

### MVVM Pattern Implementation

The application follows the **Model-View-ViewModel (MVVM)** architecture pattern:

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    View     │───▶│ ViewModel   │───▶│    Model    │
│  (SwiftUI)  │    │(@Published) │    │ (CloudKit)  │
└─────────────┘    └─────────────┘    └─────────────┘
```

### **Auth/security**

The application implemenets a secure authentication system using ****Keychain Services**** for credential sotre ****CloudKit**** for user Management

#### **Authentication Architecture**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  AuthManager    │───▶│  Keychain       │    │   CloudKit      │
│  ViewModel      │    │  Helper         │───▶│   User Records  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

##### **AuthManagerViewModel**
- **State Management**: Uses `@Published` properties for reactive UI updates
- **Guest Mode**: Allows browsing without authentication
- **Persistent Storage**: Secures user credentials in iOS Keychain
- **Automatic Session**: Restores user session on app launch

```swift
class AuthManagerViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isGuestMode = false
    @Published var currentUser: User?
    
    // Keychain-based persistence
    // Guest mode fallback
    // Automatic session restoration
}
```

##### **Apple ID Authentication Flow**

<img src="appSs/SignUpPage.png" alt="Sign Up Page" width="300"/>

*User registration and authentication interface*

1. **App Launch**: `loadUserFromKeychain()` checks for existing credentials
2. **No Credentials**: Automatically enters guest mode for browsing
3. **Login Success**: `saveUser()` stores encrypted credentials in Keychain
4. **Session Active**: User remains authenticated across app restarts
5. **Logout**: `removeUser()` securely deletes all stored credentials

#### **Views (SwiftUI)**
- `PropertyListView`: Displays list of available properties
- `PropertyDetailView`: Shows detailed property information
- `BookingView`: Handles reservation creation
- `UserProfileView`: Manages user account information
- `SearchView`: Property search and filtering interface

#### **ViewModels (@ObservableObject)**
- `PropertyViewModel`: Manages property data and CloudKit operations
- `BookingViewModel`: Handles booking logic and reservation management
- `UserViewModel`: User authentication and profile management
- `SearchViewModel`: Search functionality and filtering logic

#### **Models (CloudKit Records)**
- `Property`: Property listings with images, descriptions, pricing
- `Booking`: Reservation records linking users to properties
- `User`: User profiles and authentication data

## 🔍 Search System Architecture

### Advanced Property Search Implementation

<img src="appSs/SearchPage.png" alt="Search Page" width="300"/>

*Advanced search interface with filtering capabilities*

The search system provides comprehensive property discovery through multiple search mechanisms:

#### **Search Architecture**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SearchView    │───▶│ SearchViewModel │───▶│   CloudKit      │
│   (SwiftUI)     │    │  (@Published)   │    │   Properties    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

#### **SearchViewModel Features**
- **Real-time Search**: Instant filtering as user types
- **Smart Sorting**: Relevance-based result ordering (title → location → category)
- **Recent Searches**: Persistent search history (up to 5 recent searches)
- **Category Filtering**: Browse by property categories (Apartment, House, Villa, etc.)
- **Listing Type Filtering**: Filter by For Sale/For Rent
- **Location-based Search**: Nearby properties discovery

```swift
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchResults: [PropertyListing] = []
    @Published var isShowingResults: Bool = false
    @Published var isLoading: Bool = false
    @Published var recentSearches: [String] = []
    
    // Multi-field search implementation
    // Smart relevance sorting
    // Category and type filtering
}
```

#### **Search Capabilities**

##### **Multi-Field Search**
The search algorithm searches across multiple property fields:
- **Property Title**: Primary search field
- **Location**: City, state, area names
- **Category**: Property type (Apartment, House, Villa, etc.)
- **Description**: Full text search in property descriptions
- **Owner Name**: Search by property owner
- **Listing Type**: For Sale, For Rent classification

##### **Search Prioritization**
Results are intelligently sorted by relevance:
1. **Title Matches**: Properties with matching titles appear first
2. **Location Matches**: Location-based matches ranked second
3. **Category Matches**: Category matches follow
4. **Date Relevance**: Among equal matches, newest listings appear first

## 👤 User Profile & Management

### Profile Management System

<img src="appSs/ProfilePage.png" alt="Profile Page" width="300"/>

*User profile interface showing account information and preferences*

The user profile system provides comprehensive account management:

#### Profile Features:
- **Personal Information**: Name, contact details, profile picture
- **Property Management**: Host can manage their listings
- **Booking History**: Complete transaction history
- **Wishlist Access**: Quick access to saved properties
- **Professional Upgrade**: Option to convert to professional membership
- **Account Settings**: Privacy, notifications, and security settings

### Logout Flow

The application provides secure logout functionality across different sections:

#### Logout Screenshots
<img src="appSs/logoutInbox.png" alt="Logout Inbox" width="250"/>
<img src="appSs/logoutProfile.png" alt="Logout Profile" width="250"/>
<img src="appSs/logoutProperties.png" alt="Logout Properties" width="250"/>
<img src="appSs/logoutWishlist.png" alt="Logout Wishlist" width="250"/>

*Secure logout functionality across different app sections*

## 💰 Professional Services & Revenue

### Professional Membership

<img src="appSs/professionalSection.png" alt="Professional Section" width="300"/>

*Professional membership interface and services overview*

<img src="appSs/RealEstateSection.png" alt="Real Estate Section" width="300"/>

*Real estate professional services and tools*

<img src="appSs/servicesSection.png" alt="Services Section" width="300"/>

*Comprehensive services offered by professional members*

### Revenue Analytics

<img src="appSs/IncomeAnalytics.png" alt="Income Analytics" width="300"/>

*Detailed revenue analytics and performance metrics*

Professional members get access to:
- **Advanced Analytics**: Detailed income tracking and performance metrics
- **Enhanced Listings**: Premium property listing features
- **Professional Services**: Offer specialized real estate services
- **Priority Support**: Dedicated customer support
- **Marketing Tools**: Advanced promotion and marketing capabilities

## 💝 Wishlist & Favorites

<img src="appSs/WishlistsPage.png" alt="Wishlists Page" width="300"/>

*User wishlist showing saved properties and favorites*

The wishlist system allows users to:
- **Save Properties**: Add interesting properties for later viewing
- **Organize Collections**: Create multiple wishlists for different purposes
- **Quick Access**: Fast navigation to saved properties
- **Share Lists**: Share wishlist collections with others
- **Sync Across Devices**: CloudKit-powered synchronization

## 🏠 Property Management

<img src="appSs/MyPropertyPage.png" alt="My Property Page" width="300"/>

*Property owner interface for managing listings*

Property owners can:
- **List Properties**: Add new properties with detailed information
- **Manage Listings**: Edit, update, or remove existing properties
- **Track Performance**: Monitor property views and interest
- **Handle Bookings**: Manage reservation requests
- **Update Availability**: Real-time availability calendar management

## 💳 Transaction Management

<img src="appSs/TransactionHistory.png" alt="Transaction History" width="300"/>

*Comprehensive transaction history and payment tracking*

The transaction system provides:
- **Payment History**: Complete record of all transactions
- **Booking Payments**: Track property booking payments
- **Service Payments**: Professional service transaction history
- **Membership Payments**: Professional membership payment tracking
- **Refund Management**: Handle refunds and cancellations
- **Financial Reports**: Generate detailed financial reports

## 📨 Communication System

<img src="appSs/MessageBox.png" alt="Message Box" width="300"/>

*In-app messaging system for user communication*

The messaging system enables:
- **Direct Messaging**: Host-guest communication
- **Booking Inquiries**: Property-specific conversations
- **Service Discussions**: Professional service communications
- **System Notifications**: Automated booking and payment updates
- **Message History**: Persistent conversation records

## 📊 CloudKit Database Architecture

![Booking and Property Management](images/main.png)

### Property and Booking Management System

The core property and booking system uses multiple CloudKit databases for different functionalities:

#### Database Structure:
- **PaymentDB**: Handles all payment processing and confirmations
- **BookingDB**: Manages property bookings and reservation data
- **iCloud PrivateDB**: Stores user's private data like wishlist items
- **iCloud PublicDB**: Manages public property listings and confirmations

#### Data Flow:
- Users can add properties to their wishlist (stored in iCloud PrivateDB)
- Booking and payment information flows between BookingDB and PaymentDB
- Property listings and confirmations are maintained in the public database
- Property owners receive confirmation notifications through the iCloud PublicDB

![Members Conversion to Professional](images/memToPro.png)

### Professional Membership Management

The system includes a professional membership conversion pipeline:

#### Components:
- **PaymentDB**: Processes membership payment transactions
- **ProfessionalDB**: Stores professional user data and status

#### Process Flow:
- User receives information about professional membership
- User makes payment through PaymentDB
- Upon confirmation, ProfessionalDB updates the user's status
- User is converted to a Pro member with enhanced privileges

![Professional Services](images/ProServices.png)

### Professional Services Platform

Professional users can offer services through a dedicated system:

#### Key Elements:
- **ProfessionalDB**: Manages professional user accounts and service offerings
- **PaymentDB**: Processes service payments from regular users

#### Service Delivery Flow:
- Pros offer services through the ProfessionalDB
- Users pay to avail these services through PaymentDB
- Upon confirmation, the Pro delivers the requested service
- The system maintains the service relationship between users and professionals

![Revenue and Analytics](images/Revenue.png)

### Revenue and Analytics System

The platform includes comprehensive analytics and revenue tracking:

#### System Components:
- **BookingDB**: Source of booking data
- **ProfessionalDB**: Source of professional service data
- **PaymentDB**: Central hub collecting all financial transactions

#### Data Flow:
- BookingDB and ProfessionalDB feed transaction data to PaymentDB
- Regular users receive revenue information from their bookings/services
- Professional users receive detailed analysis of their performance
- The system provides comprehensive revenue insights to both user types

## ☁️ CloudKit Integration

### CloudKit Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SwiftUI App   │───▶│   CloudKit API  │───▶│  iCloud Database│
│   (Frontend)    │    │   (CKContainer) │    │   (Backend)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Database Schema

#### **Property Record Type**
```swift
// CloudKit Record: "Property"
- recordID: CKRecord.ID
- title: String
- description: String
- price: Double
- location: String
- images: [CKAsset]
- amenities: [String]
- hostID: CKRecord.Reference
```

#### **Booking Record Type**
```swift
// CloudKit Record: "Booking"
- recordID: CKRecord.ID
- propertyID: CKRecord.Reference
- userID: CKRecord.Reference
- checkIn: Date
- checkOut: Date
- totalPrice: Double
- status: String
```

#### **User Record Type**
```swift
// CloudKit Record: "User"
- recordID: CKRecord.ID
- name: String
- email: String
- profileImage: CKAsset
- userType: String (guest/host)
```

#### **Professional Record Type**
```swift
// CloudKit Record: "Professional"
- recordID: CKRecord.ID
- userID: CKRecord.Reference
- membershipType: String
- serviceOfferings: [String]
- expertise: [String]
- verificationStatus: Bool
```

#### **Payment Record Type**
```swift
// CloudKit Record: "Payment"
- recordID: CKRecord.ID
- userID: CKRecord.Reference
- amount: Double
- paymentType: String (booking/service/membership)
- relatedRecordID: CKRecord.Reference
- status: String
- timestamp: Date
```

### CloudKit Operations in ViewModels

#### **PropertyViewModel**
```swift
class PropertyViewModel: ObservableObject {
    @Published var properties: [Property] = []
    private let container = CKContainer.default()
    
    // Fetch properties from CloudKit
    func fetchProperties() {
        let query = CKQuery(recordType: "Property", predicate: NSPredicate(value: true))
        // CloudKit operation to fetch records
    }
    
    // Save property to CloudKit
    func saveProperty(_ property: Property) {
        let record = CKRecord(recordType: "Property")
        // Convert property to CloudKit record and save
    }
}
```

#### **BookingViewModel**
```swift
class BookingViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    
    // Create booking with CloudKit reference
    func createBooking(propertyID: CKRecord.ID, userID: CKRecord.ID) {
        let record = CKRecord(recordType: "Booking")
        record["propertyID"] = CKRecord.Reference(recordID: propertyID, action: .deleteSelf)
        // Save booking record
    }
}
```

#### **ProfessionalViewModel**
```swift
class ProfessionalViewModel: ObservableObject {
    @Published var professionals: [Professional] = []
    @Published var professionalServices: [Service] = []
    
    // Convert regular user to professional
    func convertToProfessional(userID: CKRecord.ID) {
        let record = CKRecord(recordType: "Professional")
        record["userID"] = CKRecord.Reference(recordID: userID, action: .none)
        record["membershipType"] = "standard"
        record["verificationStatus"] = false
        // Save professional record
    }
    
    // Add professional service
    func addService(professionalID: CKRecord.ID, service: Service) {
        let record = CKRecord(recordType: "Service")
        record["professionalID"] = CKRecord.Reference(recordID: professionalID, action: .deleteSelf)
        // Save service details
    }
}
```

### Data Flow Architecture

```
User Interaction
       ↓
SwiftUI View
       ↓ (Action)
ViewModel (@Published properties update)
       ↓ (CloudKit API calls)
CloudKit Container
       ↓ (Network request)
iCloud Database
       ↓ (Response)
CloudKit Container
       ↓ (Parsed data)
ViewModel (updates @Published properties)
       ↓ (Automatic UI refresh)
SwiftUI View
```

## 🔄 Real-time Synchronization

### CloudKit Subscriptions
- **Property updates**: Real-time notifications when new properties are added
- **Booking changes**: Instant updates when reservations are modified
- **User profile changes**: Automatic sync across devices
- **Professional service updates**: Notifications when new services are available
- **Payment confirmations**: Instant payment status updates

## 🚀 Features

### Core Functionality
- **Property Browsing**: Browse available rental properties
- **Search & Filter**: Advanced search with location, price, and amenity filters
- **Booking System**: Complete reservation management
- **User Profiles**: Host and guest profile management
- **Real-time Sync**: Cross-device synchronization via CloudKit
- **Professional Membership**: Upgrade path for professional hosts
- **Service Marketplace**: Platform for professional services

### CloudKit-Powered Features
- **Analytics Dashboard**: Revenue tracking and performance metrics

## 📱 Setup Instructions

1. **Enable CloudKit capability** in Xcode project settings
3. **Configure iCloud account** on testing device
4. **Build and run** the application

## 📊 Data Relationships

```
                  ┌───────────┐
                  │  Payment  │
                  └─────┬─────┘
                        │
                        ▼
┌───────┐      ┌────────────────┐      ┌────────────┐
│  User │◄─────┤     Booking    │─────▶│  Property  │
└───┬───┘      └────────────────┘      └──────┬─────┘
    │                                         │
    │                                         │
    └─────────────┐               ┌───────────┘
                  ▼               ▼
            ┌──────────────────────────┐
            │      Professional        │
            └──────────────────────────┘
```

This architecture ensures efficient data management, real-time synchronization, and a responsive user interface.
