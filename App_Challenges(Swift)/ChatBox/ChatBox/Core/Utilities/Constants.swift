//
//  Constants.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 25/04/25.
//

import Foundation
import SwiftUI

struct Constants {
    struct Strings {
        let appTitle = "ChatBox"
        let startNewChatMessage = "Start a new chat session!"
        let descMessage = "Test messages, try conversations, and explore the chat features."
        let newChat = "New Chat";
        let placeholderText = "Type here..."
        let chat = "Chat"
        let unreadMessages = "Unread Message(s)"
        let noInternetConnections = "No internet connection"
    }
    
    struct Images {
        let plusImage = Image(systemName: "plus")
        let backImage = Image(systemName: "chevron.left")
        let sendImage = Image(systemName: "paperplane")
    }
    
    struct Spacing {
        let tiny: CGFloat = 1
        let verySmall: CGFloat = 2
        let small: CGFloat = 8
        let medium: CGFloat = 10
        let extraSmall: CGFloat = 12
        let regular: CGFloat = 18
        let large: CGFloat = 20
        let extraLarge: CGFloat = 22
        let jumbo: CGFloat = 48
        let huge: CGFloat = 125
    }
}
