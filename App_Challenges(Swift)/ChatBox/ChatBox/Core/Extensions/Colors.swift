//
//  Colors.swift
//  ChatBox
//
//  Created by Dhruv Upadhyay on 26/04/25.
//

import Foundation
import SwiftUI

extension Color {
    static let backgroundF7F7F8 = Color(hex: "#F7F7F8")
    static let backgroundEFEFEF = Color(hex: "#EFEFEF")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1) // fallback white if wrong hex
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
