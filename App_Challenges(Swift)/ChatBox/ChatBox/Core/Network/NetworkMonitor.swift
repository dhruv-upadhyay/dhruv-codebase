//
//  NetworkMonitor.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import Network
import Combine

protocol NetworkMonitorProtocol: AnyObject {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkMonitor: NetworkMonitorProtocol, ObservableObject {
    
    static let shared = NetworkMonitor()
    
    @Published private(set) var isConnected: Bool = true
    
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            DispatchQueue.main.async {
                switch path.status {
                case .requiresConnection, .satisfied:
                    self.isConnected = true
                default:
                    self.isConnected = false
                }
            }
        }
        monitor?.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
