//
//  ChatModels.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import Foundation

class ChatSession: Identifiable, ObservableObject, Codable {
    let id: UUID
    @Published var title: String
    @Published var messages: [ChatMessage]
    @Published var isUnread: Bool
    @Published var unreadCount: Int
    @Published var lastReadMessageID : UUID? = nil
    
    init(
        id: UUID = UUID(),
        title: String = "",
        messages: [ChatMessage] = [],
        isUnread: Bool = false,
        unreadCount: Int = 0,
        lastReadMessageID: UUID? = nil) {
            self.id = id
            self.title = title
            self.messages = messages
            self.isUnread = isUnread
            self.unreadCount = unreadCount
            self.lastReadMessageID = lastReadMessageID
        }
    
    enum CodingKeys: CodingKey {
        case id, title, messages, isUnread, unreadCount, lastReadMessageID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.messages = try container.decode([ChatMessage].self, forKey: .messages)
        self.isUnread = try container.decode(Bool.self, forKey: .isUnread)
        self.unreadCount = try container.decode(Int.self, forKey: .unreadCount)
        self.lastReadMessageID = try container.decodeIfPresent(UUID.self, forKey: .lastReadMessageID)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(messages, forKey: .messages)
        try container.encode(isUnread, forKey: .isUnread)
        try container.encode(unreadCount, forKey: .unreadCount)
        try container.encodeIfPresent(lastReadMessageID, forKey: .lastReadMessageID)
    }
}

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), content: String, isUser: Bool, timestamp: Date) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}
