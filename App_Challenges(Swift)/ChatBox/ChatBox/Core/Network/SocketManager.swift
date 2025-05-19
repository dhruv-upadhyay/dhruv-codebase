//
//  SocketManager.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import Foundation
import Network
import Combine

final class SocketManager: NSObject {
    
    // MARK: - Properties
    private var webSocketTask: URLSessionWebSocketTask?
    private var failedMessages: [String] = []
    private let networkMonitor: NetworkMonitorProtocol
    private var isConnectedToNetwork: Bool = true
    private var cancellable: AnyCancellable?
    private let url: URL
    
    // MARK: - Callback
    var onMessageReceived: ((String) -> Void)?
    
    // MARK: - Init
    init(url: URL, networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared) {
        self.url = url
        self.networkMonitor = networkMonitor
        super.init()
        
        self.networkMonitor.startMonitoring()
    }
    
    // MARK: - Create connection
    func connect() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        listen()
    }
    
    // MARK: - Send message
    func send(_ message: String) {
        guard isConnectedToNetwork else {
            failedMessages.append(message)
            return
        }
        
        webSocketTask?.send(.string(message)) { [weak self] error in
            guard let self else { return }
            if let error = error {
                print("Send error: \(error)")
                self.failedMessages.append(message)
            }
        }
    }
    
    // MARK: - Listen method (Read response)
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                print("Listen error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self.onMessageReceived?(text)
                default:
                    break
                }
            }
            self.listen()
        }
    }
    
    // MARK: - Cancel connection
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    // MARK: - Retry Logic
    func retryFailedMessages() {
        guard isConnectedToNetwork else { return }
        
        while !failedMessages.isEmpty {
            let message = failedMessages.removeFirst()
            send(message)
        }
    }
    
    // MARK: - Monitor network connection state changes
    private func observeNetworkChanges() {
        cancellable = NetworkMonitor.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self else { return }
                self.isConnectedToNetwork = isConnected
                if isConnected {
                    self.retryFailedMessages()
                }
            }
    }
}

// MARK: - URLSessionWebSocketDelegate
extension SocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        retryFailedMessages()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
    }
}
