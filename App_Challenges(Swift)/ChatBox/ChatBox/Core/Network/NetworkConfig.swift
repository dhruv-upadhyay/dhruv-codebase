//
//  NetworkConfig.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 25/04/25.
//

import Foundation

struct NetworkConfig {
    static let baseURL = "wss://s14532.blr1.piesocket.com/v3"
    static let apiKey = "1CB71WlaO8E43ewCoo6u0yYXlKTqfsCdsA44ULih"

    static func socketURL(for roomID: String) -> URL {
        return URL(string: "\(baseURL)/\(roomID)?api_key=\(apiKey)")!
    }
}

