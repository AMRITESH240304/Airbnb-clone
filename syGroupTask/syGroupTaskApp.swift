//
//  syGroupTaskApp.swift
//  syGroupTask
//
//  Created by Amritesh Kumar on 02/09/25.
//

import SwiftUI

@main
struct syGroupTaskApp: App {
    @StateObject private var authViewModel = AuthManagerViewModel()
    @StateObject private var cloudKitViewModel = CloudkitManagerViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(cloudKitViewModel)
        }
    }
}
