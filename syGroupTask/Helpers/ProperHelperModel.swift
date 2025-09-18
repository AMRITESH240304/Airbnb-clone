//
//  ProperHelperModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 17/09/25.
//

import Foundation

struct PropertyFormData {
    var title: String
    var category: String
    var location: String
    var description: String
    var listingType: ListingType
    var price: String
    var monthlyRent: String
    var listingDuration: Int
    var photoURLs: [String]
    
    var latitude: Double
    var longitude: Double
    
    var isStudentAccommodation: Bool
    var genderPreference: String?
    
    var isOverseas: Bool
    var country: String?

    static func fromFormData(
        title: String,
        category: String,
        location: String,
        description: String,
        listingType: String,
        price: String,
        monthlyRent: String,
        listingDuration: Int,
        photoURLs: [String],
        latitude: Double = 0,
        longitude: Double = 0,
        isStudentAccommodation: Bool = false,
        genderPreference: String? = nil,
        isOverseas: Bool = false,
        country: String? = nil
    ) -> PropertyFormData {
        let type: ListingType =
            (listingType == "For Sale") ? .forSale : .forRent

        return PropertyFormData(
            title: title,
            category: category,
            location: location,
            description: description,
            listingType: type,
            price: price,
            monthlyRent: monthlyRent,
            listingDuration: listingDuration,
            photoURLs: photoURLs,
            latitude: latitude,
            longitude: longitude,
            isStudentAccommodation: isStudentAccommodation,
            genderPreference: genderPreference,
            isOverseas: isOverseas,
            country: country
        )
    }
}

