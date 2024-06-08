//
//  AttributedText.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    class func setAttributedLabel(text: String, textColor: UIColor? = nil, textFont: UIFont? = nil, styledText: String? = nil, styledTextColor: UIColor? = nil, styledTextFont: UIFont? = nil, links: [FormLinkData]? = nil, linkColor: UIColor? = nil, linkFont: UIFont? = nil, styledStrings: [String]? = nil, textParagraphStyle: NSMutableParagraphStyle? = nil, styledTextParagraphStyle: NSMutableParagraphStyle? = nil) -> (NSMutableAttributedString, [NSAttributedString.Key: Any]?) {
        let themeAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.customFont(style: .footnote, size: 12.0), NSAttributedString.Key.foregroundColor: UIColor.BrandColour.Custom.black]
        var linkAttributes = [NSAttributedString.Key: Any]()

        let attributedString = NSMutableAttributedString(string: text, attributes: themeAttributes)

        if let textColor = textColor {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: (attributedString.string as NSString).range(of: text))
        }

        if let textFont = textFont {
            attributedString.addAttribute(NSAttributedString.Key.font, value: textFont, range: NSRange(location: 0, length: attributedString.length))
        }

        if let paragraphStyle = textParagraphStyle {
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: (attributedString.string as NSString).range(of: text))
        }

        if let styledText = styledText {
            if let styleTextColor = styledTextColor {
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: styleTextColor, range: (attributedString.string as NSString).range(of: styledText))
            }

            if let styledTextFont = styledTextFont {
                attributedString.addAttribute(NSAttributedString.Key.font, value: styledTextFont, range: (attributedString.string as NSString).range(of: styledText))
            }

            if let paragraphStyle = styledTextParagraphStyle {
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: (attributedString.string as NSString).range(of: styledText))
            }
        } else if let styledStrings = styledStrings {
            for styledText in styledStrings {
                if let styleTextColor = styledTextColor {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: styleTextColor, range: (attributedString.string as NSString).range(of: styledText))
                }

                if let styledTextFont = styledTextFont {
                    attributedString.addAttribute(NSAttributedString.Key.font, value: styledTextFont, range: (attributedString.string as NSString).range(of: styledText))
                }

                if let paragraphStyle = styledTextParagraphStyle {
                    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: (attributedString.string as NSString).range(of: styledText))
                }
            }
        }

        if let links = links {
            for link in links {
                if let linkColor = linkColor {
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: linkColor, range: (attributedString.string as NSString).range(of: link.text))
                }

                if let linkFont = linkFont {
                    attributedString.addAttribute(NSAttributedString.Key.font, value: linkFont, range: (attributedString.string as NSString).range(of: link.text))
                }

                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: (attributedString.string as NSString).range(of: link.text))
            }
        }

        if let linkFont = linkFont {
            linkAttributes[NSAttributedString.Key.font] = linkFont
        }

        if let linkColor = linkColor {
            linkAttributes[NSAttributedString.Key.foregroundColor] = linkColor
        }

        return (attributedString, linkAttributes)
    }
}


extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
        return ceil(boundingBox.width)
    }
}

extension String {
    
    func underlined(_ style: NSUnderlineStyle.RawValue = NSUnderlineStyle.single.rawValue, color: UIColor = UIColor.BrandColour.Custom.black) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: style,
            .foregroundColor: color
        ]
        
        return setAttributes(attributes)
    }
    
    func bold(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
           .font: UIFont.customFont(style: .footnote, size: 12.0, traits: .traitBold)
        ]
       
        return setAttributes(attributes)
    }

    func normal(_ value: String) -> NSMutableAttributedString {
       let attributes: [NSAttributedString.Key: Any] = [
           .font: UIFont.customFont(style: .footnote, size: 12.0)
       ]
       
        return setAttributes(attributes)
    }

    /* Other styling methods */
    func orangeHighlight(_ value: String) -> NSMutableAttributedString {
       let attributes: [NSAttributedString.Key: Any] = [
           .font: UIFont.customFont(style: .footnote, size: 12.0),
           .foregroundColor: UIColor.white,
           .backgroundColor: UIColor.orange
       ]
       
        return setAttributes(attributes)
    }

    func blackHighlight(_ value: String) -> NSMutableAttributedString {
       let attributes: [NSAttributedString.Key: Any] = [
           .font: UIFont.customFont(style: .footnote, size: 12.0),
           .foregroundColor: UIColor.white,
           .backgroundColor: UIColor.black
       ]
       
        return setAttributes(attributes)
    }
    
    func setAttributes(_ attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let attributedStr = NSMutableAttributedString()
        attributedStr.append(NSAttributedString(string: self, attributes: attributes))
        return attributedStr
    }
    
    func htmlAttributed(family: String = "Roboto", size: CGFloat = 12.0, color: UIColor = UIColor.BrandColour.Custom.black, lineHeight: CGFloat = 21.0) -> NSAttributedString? {
        guard let collorHex = color.hexString else {
            return nil
        }
        
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "font-family: \(family) !important;" +
                "line-height: \(lineHeight)px !important;" +
                "color: #\(collorHex) !important;" +
            "}</style> \(self)"
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    func getSubstringFromTag(tag: String) -> [String]? {
        guard !self.isEmpty else {
            return nil
        }
        var results = [String]()
        do {
            let regex = try NSRegularExpression(pattern: "<\(tag)>(.*?)</\(tag)>", options: [])
            regex.enumerateMatches(in: self, options: [], range: self.asAttributedString().mutableString.range(of: self)) { result, _, _ in
                if let r = result?.range(at: 1), let range = Range(r, in: self) {
                    results.append(String(self[range]))
                }
            }
            
        } catch {
            debugPrint("Error \(error)")
            return nil
        }
        
        return results
    }
    
    func asAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [:])
    }
}
