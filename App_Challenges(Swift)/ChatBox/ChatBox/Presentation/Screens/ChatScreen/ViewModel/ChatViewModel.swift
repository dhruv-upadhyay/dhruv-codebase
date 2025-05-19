//
//  ChatViewModel.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject, Identifiable, Hashable {
    // MARK: - Properties
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isConnection: Bool = false
    @Published var isConnectedToNetwork = true
    
    let id: String
    let roomID: String
    let spacing = Constants.Spacing()
    let strings = Constants.Strings()
    let images = Constants.Images()
    
    var isChatScreen: Bool = false
    var unreadCount: Int = 0
    var chatSession: ChatSession
    
    private var cancellable: AnyCancellable?
    private var socketManager: SocketManager?

    // MARK: - Initialization
    init(roomID: String, chatSession: ChatSession) {
        self.id = UUID().uuidString
        self.roomID = roomID
        self.chatSession = chatSession
        self.socketManager = SocketManager(url: NetworkConfig.socketURL(for: roomID))
        
        setupSocketCallbacks() /// socket callbacks
        socketManager?.connect() /// Establish socket connection
        observeNetworkChanges() /// Observ network connection
    }

    // MARK: - Private Methods
    private func setupSocketCallbacks() {
        socketManager?.onMessageReceived = { [weak self] message in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let botMessage = ChatMessage(content: message, isUser: false, timestamp: Date())
                self.messages.append(botMessage)
                if !isChatScreen {
                    self.chatSession.isUnread = true
                    self.chatSession.unreadCount += 1
                    if self.chatSession.lastReadMessageID == nil {
                        self.chatSession.lastReadMessageID = botMessage.id
                    }
                }
            }
        }        
    }
    
    private func observeNetworkChanges() {
        cancellable = NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                self.isConnectedToNetwork = isConnected
            }
    }

    // MARK: - Public Methods
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let userMessage = ChatMessage(content: inputText, isUser: true, timestamp: Date())
        messages.append(userMessage)
        socketManager?.send(inputText)
        inputText = ""
        chatSession.isUnread = false
    }
    
    func markMessagesAsRead() {
        unreadCount = chatSession.unreadCount
        chatSession.unreadCount = 0
        chatSession.isUnread = false
    }
    
    func updateOnBack(){
        isChatScreen = false
        chatSession.lastReadMessageID = nil
        unreadCount = 0
    }

    // MARK: - Hashable Conformance
    static func == (lhs: ChatViewModel, rhs: ChatViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Deinit
    deinit {
        socketManager?.disconnect()
    }
}
