//
//  Label.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import UIKit

@objc protocol LabelDelegate: AnyObject {
    @objc optional
    func onLinkPressed(text: String, url: String?)
}

class Label: UILabel {
    
    struct Design {
        struct sizes {
            static let size_24: CGFloat = 24.0
            static let size_20: CGFloat = 20.0
            static let size_18: CGFloat = 18.0
            static let size_16: CGFloat = 16.0
            static let size_14: CGFloat = 14.0
            static let size_12: CGFloat = 12.0
        }
        
        struct colors {
            static let whiteColor = UIColor.white
            static let titleColor = UIColor.BrandColour.Custom.gunmetal
            static let errorColor = UIColor.BrandColour.Custom.errorColor
            static let valueColor = UIColor.BrandColour.Custom.convertedValueColor
            static let descColor = UIColor.BrandColour.Custom.descValueColor
        }
    }
    
    weak var delegate: LabelDelegate?
    var color: UIColor?
    private var links: [FormLinkData]?
    var insets = UIEdgeInsets.zero

    init(type: LabelType = .head) {
        super.init(frame: .zero)
        
        setTheme(type)
    }
    
    init(type: LabelType = .head, frame: CGRect) {
        super.init(frame: frame)
        
        setTheme(type)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTheme(.head)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setTheme(.head)
    }
    
    override func drawText(in rect: CGRect) {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: textRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        return contentSize
    }
    
    func setTheme(_ type: LabelType) {
        switch type {
        case .head:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_24, alignment: .center, color: Design.colors.titleColor, name: FontName.MontserratBold.rawValue)
        case .countryName:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_16, alignment: .center, color: Design.colors.titleColor, name: FontName.MontserratBold.rawValue)
        case .errorLabel:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_12, alignment: .left, color: Design.colors.errorColor, name: FontName.MontserratMedium.rawValue)
        case .convertedValue:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_24, alignment: .right, color: Design.colors.valueColor, name: FontName.MontserratBold.rawValue)
        case .currenciesTitle:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_20, alignment: .left, color: Design.colors.titleColor, name: FontName.MontserratSemiBold.rawValue)
        case .popupCountryName:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_18, alignment: .left, color: Design.colors.titleColor, name: FontName.MontserratSemiBold.rawValue)
        case .popupCountryDesc:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_12, alignment: .left, color: Design.colors.descColor, name: FontName.MontserratItalic.rawValue)
        }
    }
    
    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    private func setCustomTheme(textStyle: UIFont.TextStyle, fontSize: CGFloat, alignment: NSTextAlignment, traits: UIFontDescriptor.SymbolicTraits? = nil, weight: UIFont.Weight? = nil, color: UIColor, name: String? = FontName.MontserratRegular.rawValue) {
        self.color = color
        numberOfLines = 0
        textColor = color
        textAlignment = alignment
        
        if let weight = weight {
            font = UIFont.customFont(style: textStyle, size: fontSize, traits: traits, name: name).with(weight: weight)
        }
        else {
            font = UIFont.customFont(style: textStyle, size: fontSize, traits: traits, name: name)
        }
        
    }

    func setText(_ title: String, upperCased: Bool = false) {
        text = upperCased ? title.uppercased() : title
        
        if !title.isEmpty {
            applyAccessibility(text: title)
        }
    }
    
    func setAttributedString(_ attributedString: NSAttributedString?) {
        guard let attributedString = attributedString else {
            return
        }
        
        if !attributedString.string.isEmpty {
            applyAccessibility(text: attributedString.string)
        }
        
        let (attributedAccessibleString, _) = NSMutableAttributedString.setAttributedLabel(text: attributedString.string, textColor: textColor, textFont: font, styledText: nil, styledTextColor: nil, styledTextFont: nil, links: nil, linkColor: nil, linkFont: nil)
        attributedText = attributedAccessibleString
    }
    
    func setAttributedText(_ title: String, links: [FormLinkData]?, linkColor: UIColor?, linkFont: UIFont?, styledText: String? = nil, styledTextColor: UIColor? = nil, styledTextFont: UIFont? = nil, textParagraphStyle: NSMutableParagraphStyle? = nil, styledTextParagraphStyle: NSMutableParagraphStyle? = nil) {
        text = title
        applyAccessibility(text: title)
        
        if let links = links {
            self.links = links
            let (attributedString, _) = NSMutableAttributedString.setAttributedLabel(text: title, textColor: textColor, textFont: font, styledText: nil, styledTextColor: nil, styledTextFont: nil, links: links, linkColor: linkColor, linkFont: linkFont, textParagraphStyle: textParagraphStyle, styledTextParagraphStyle: styledTextParagraphStyle)
            attributedText = attributedString
        } else if let styledText = styledText {
            let (attributedString, _) = NSMutableAttributedString.setAttributedLabel(text: title, textColor: textColor, textFont: font, styledText: styledText, styledTextColor: styledTextColor, styledTextFont: styledTextFont, links: nil, linkColor: nil, linkFont: nil, textParagraphStyle: textParagraphStyle, styledTextParagraphStyle: styledTextParagraphStyle)
            attributedText = attributedString
        } else if let textParagraphStyle = textParagraphStyle {
            let (attributedString, _) = NSMutableAttributedString.setAttributedLabel(text: title, textColor: textColor, textFont: font, styledText: nil, styledTextColor: nil, styledTextFont: nil, links: nil, linkColor: nil, linkFont: nil, textParagraphStyle: textParagraphStyle, styledTextParagraphStyle: nil)
            attributedText = attributedString
        }
    }
    
    func setAttributedText(_ title: String, styledStrings: [String]? = nil, styledTextColor: UIColor? = nil, styledTextFont: UIFont? = nil) {
        text = title
        applyAccessibility(text: title)
        
        let (attributedString, _) = NSMutableAttributedString.setAttributedLabel(text: title, textColor: textColor, textFont: font, styledText: nil, styledTextColor: styledTextColor, styledTextFont: styledTextFont, links: nil, linkColor: nil, linkFont: nil, styledStrings: styledStrings)
        attributedText = attributedString
    }
    
    func setEnabled(_ enabled: Bool) {
        textColor = enabled ? color : Design.colors.whiteColor
    }
    
    func setTextWithIcon(text: String, iconName: ImageName, color: UIColor? = nil) {
        let imageAttachment = NSTextAttachment()
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.image = UIImage(named: iconName.rawValue)
        if let color = color {
            imageAttachment.image?.withTintColor(color)
        }
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image?.size.width ?? 20.0, height: imageAttachment.image?.size.height ?? 20.0)
        
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: text)
        completeText.append(textAfterIcon)
    
        setAttributedString(completeText)
    }
    
    func setColor(color: UIColor) {
        self.color = color
        textColor = color
    }
    
    private func setFontSize(size:CGFloat) -> CGFloat{
        return UIScreen.main.bounds.height * size
    }
}
