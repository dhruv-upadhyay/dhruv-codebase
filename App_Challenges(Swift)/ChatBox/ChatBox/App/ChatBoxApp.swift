//
//  ChatBoxApp.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 25/04/25.
//

import SwiftUI

@main
struct ChatBoxApp: App {
    init() {
        NetworkMonitor.shared.startMonitoring() /// Star monitoring internet connection, so can update to all screen.
    }
    
    var body: some Scene {
        WindowGroup {
            ChatListView()
        }
    }
}
