//
//  Font.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

enum FontWeight:CGFloat {
    case Weight700 = 700
    case Weight400 = 400
    case Weight200 = 200
    case Weight50 = 50
}

enum FontName: String {
    case MontserratBlack = "Montserrat-Black"
    case MontserratBlackItalic = "Montserrat-BlackItalic"
    case MontserratBold = "Montserrat-Bold"
    case MontserratBoldItalic = "Montserrat-BoldItalic"
    case MontserratExtraBold = "Montserrat-ExtraBold"
    case MontserratExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    case MontserratExtraLight = "Montserrat-ExtraLight"
    case MontserratExtraLightItalic = "Montserrat-ExtraLightItalic"
    case MontserratItalic = "Montserrat-Italic"
    case MontserratLight = "Montserrat-Light"
    case MontserratLightItalic = "Montserrat-LightItalic"
    case MontserratMedium = "Montserrat-Medium"
    case MontserratMediumItalic = "Montserrat-MediumItalic"
    case MontserratRegular = "Montserrat-Regular"
    case MontserratSemiBold = "Montserrat-SemiBold"
    case MontserratSemiBoldItalic = "Montserrat-SemiBoldItalic"
    case MontserratThin = "Montserrat-Thin"
    case MontserratThinItalic = "Montserrat-ThinItalic"
}

extension UIFont {
    
    /// To call: UIFont.brandFont(ofSize: 12.0, weight: .regular, type: .button)
    class func brandFont(weight: Weight? = .regular, type: FontInputType? = nil, style: TextStyle? = nil) -> UIFont {
        var fontSize: CGFloat = 12.0
        if let type = type {
            switch type {
            case .small:
                fontSize = smallSystemFontSize
            case .system:
                fontSize = systemFontSize
            case .label:
                fontSize = labelFontSize
            case .button:
                fontSize = buttonFontSize
            }
            
            return systemFont(ofSize: fontSize, weight: weight ?? .regular)
        }
        
        if let weight = weight {
            let font = preferredFont(forTextStyle: style ?? .body)
            return font.with(weight: weight)
        }
        
        return preferredFont(forTextStyle: style ?? .body)
    }
    
    class func customFont(style: TextStyle = .body, size: CGFloat = 14.0, weight: Weight = .regular, traits: UIFontDescriptor.SymbolicTraits? = nil, name: String? = "Montserrat") -> UIFont {
        if var font = UIFont(name: name ?? "Montserrat", size: size) {
            if let traits = traits {
                font = font.withTraits(traits: traits)
            }
            
            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }
        
        return brandFont(weight: weight, style: style)
    }
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        if let descriptor = fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: descriptor, size: 0) // size 0 means keep the size as it is
        }
        
        return self
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func expanded() -> UIFont {
        return withTraits(traits: .traitExpanded)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}

