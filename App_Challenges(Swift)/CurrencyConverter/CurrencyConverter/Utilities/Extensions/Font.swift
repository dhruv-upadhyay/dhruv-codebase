//
//  Font.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation
import UIKit

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
    
    class func customFont(style: TextStyle = .body, size: CGFloat = 16.0, weight: Weight = .regular, traits: UIFontDescriptor.SymbolicTraits? = nil, name: String? = "Roboto") -> UIFont {
        if var font = UIFont(name: name ?? "Roboto", size: size) {
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
