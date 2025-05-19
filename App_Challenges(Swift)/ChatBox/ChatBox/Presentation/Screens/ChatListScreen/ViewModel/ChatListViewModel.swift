//
//  ChatListViewModel.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import Foundation
import Combine

class ChatListViewModel: ObservableObject {
    @Published var chatSessions: [ChatViewModel] = []
    @Published var isConnectedToNetwork = true
    
    private var cancellables: [String: AnyCancellable] = [:]
    private var cancellable: AnyCancellable?
    private var usedRoomIDs: Set<String> = []

    let spacing = Constants.Spacing()
    let images = Constants.Images()
    let strings = Constants.Strings()

    init() {
        observeNetworkChanges()
    }
    
    /// Create new chat
    func createNewChat() -> ChatViewModel {
        let newRoomID = generateUniqueRoomID()
        let session = ChatViewModel(roomID: newRoomID,
                                    chatSession: ChatSession(title: "", messages: [], isUnread: false))
        observe(session)
        chatSessions.append(session)
        usedRoomIDs.insert(newRoomID)
        return session
    }
    
    /// Get title method
    func title(for session: ChatViewModel) -> String {
        session.messages.first?.content ?? strings.newChat
    }
    
    /// Generate Unique ID
    private func generateUniqueRoomID() -> String {
        var newID: String
        repeat {
            newID = String(Int.random(in: 10000...99999))
        } while usedRoomIDs.contains(newID)
        return newID
    }

    /// Observe methods
    func observe(_ session: ChatViewModel) {
        let cancellable = session.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.objectWillChange.send()
            }
        cancellables[session.id] = cancellable
    }
    
    private func observeNetworkChanges() {
        cancellable = NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                self.isConnectedToNetwork = isConnected
            }
    }
    
    /// Clear empty sessions
    func cleanEmptySessions() {
        chatSessions.removeAll { $0.messages.isEmpty }
        for key in cancellables.keys {
            if !chatSessions.contains(where: { $0.id == key }) {
                cancellables.removeValue(forKey: key)
            }
        }
    }
}

