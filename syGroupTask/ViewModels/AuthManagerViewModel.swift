//
//  AuthManagerViewModel.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 16/09/25.
//

import Foundation

class AuthManagerViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isGuestMode = false
    @Published var currentUser: User?
    
    private let userKey = "appleUser"
    
    init() {
        loadUserFromKeychain()
        
        if currentUser == nil {
            enterGuestMode()
        }
    }
    
    func enterGuestMode() {
        self.isGuestMode = true
        self.isAuthenticated = false
        self.currentUser = nil
    }
    
    func exitGuestMode() {
        self.isGuestMode = false
    }
    
    func saveUser(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            KeychainHelper.save(key: userKey, data: data)
            self.currentUser = user
            self.isAuthenticated = true
            self.isGuestMode = false
        }
    }
    
    func loadUserFromKeychain() {
        if let data = KeychainHelper.read(key: userKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
            self.isAuthenticated = true
            self.isGuestMode = false
        }
    }
    
    func removeUser() {
        KeychainHelper.delete(key: userKey)
        self.currentUser = nil
        self.isAuthenticated = false
        self.isGuestMode = true
    }
}
