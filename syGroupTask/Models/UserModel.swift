//
//  User.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 16/09/25.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String?
    let firstName: String?
    let lastName: String?
    
    var fullName: String? {
        if let firstName = firstName, let lastName = lastName {
            return "\(firstName) \(lastName)"
        } else if let firstName = firstName {
            return firstName
        } else if let lastName = lastName {
            return lastName
        }
        return nil
    }
}
