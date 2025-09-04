//
//  color_hex.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import Foundation
import SwiftUI

struct Theme {
    static let primaryColor = Color(hex: "FF385C")
    
    static let textPrimary = Color(hex: "000000")   // Black
    static let textSecondary = Color(hex: "717171") // Gray text
    static let textLight = Color(hex: "FFFFFF")     // White
    
    // Backgrounds
    static let background = Color(hex: "FFFFFF")          // White background
    static let backgroundSecondary = Color(hex: "F7F7F7") // Light gray card/search bar
    
    // Supporting colors
    static let accent = Color(hex: "00A699") // Airbnb teal accent (for special highlights)
    static let warning = Color(hex: "FF5A5F") // Alternate red if needed
    static let star = Color(hex: "FFB400")    // Golden star rating
    
    // Contrast colors
    static let onPrimary = Color(hex: "FFFFFF") // Text/icons on primary
    static let onBackground = Color(hex: "000000")
}
