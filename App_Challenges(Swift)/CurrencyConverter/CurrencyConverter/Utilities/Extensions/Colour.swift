//
//  Colour.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation
import UIKit

extension UIColor {

    var hexString: String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
    
    public convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = UInt8((hex & 0xFF0000) >> 16)
        let g = UInt8((hex & 0xFF00) >> 8)
        let b = UInt8(hex & 0xFF)
        self.init(red8: r, green8: g, blue8: b, alpha: alpha)
    }
    
    public convenience init(red8: UInt8, green8: UInt8, blue8: UInt8, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red8) / 255.0, green: CGFloat(green8) / 255.0, blue: CGFloat(blue8) / 255.0, alpha: alpha)
    }
}
// swiftlint:enable large_tuple

/// Custom Project Colors
extension UIColor {
    struct BrandColour {

        struct Navigation {
            static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        struct Custom {
            static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // UIColor(hex: 0xFFFFFF)
            static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // UIColor(hex: 0xFFFFFF)
            static let gunmetal = #colorLiteral(red: 0.137254902, green: 0.1960784314, blue: 0.262745098, alpha: 1) // #233243
            static let placeHolderColor = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1) // #D3D3D3
            static let errorColor = #colorLiteral(red: 0.9411764706, green: 0.2705882353, blue: 0.2705882353, alpha: 1) // #F04545
            static let textFieldBackground = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) // #F5F5F5
            static let viewBackgroundColor = #colorLiteral(red: 0.937254902, green: 0.9764705882, blue: 0.9725490196, alpha: 1) // #EFF9F8
            static let convertedValueColor = #colorLiteral(red: 0.3960784314, green: 0.7490196078, blue: 0.7294117647, alpha: 1) // #65BFBA
            static let descValueColor = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1) // #757575
        }
        
        struct Shadow {
            static let gray = #colorLiteral(red: 0, green: 0.1333333333, blue: 0.3568627451, alpha: 0.11) // UIColor(hex: 00225B, alpha: 11%)
        }
        
        struct Border {
            static let gray = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2031785103) // rgba(0, 0, 0, 0.2)
            static let separator = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1) // UIColor(hex: 0xF9F9F9)
            static let textFieldBorder = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1) // #D3D3D3
            static let errorBorder = #colorLiteral(red: 0.9411764706, green: 0.2705882353, blue: 0.2705882353, alpha: 1) // #F04545
        }
    }
}
