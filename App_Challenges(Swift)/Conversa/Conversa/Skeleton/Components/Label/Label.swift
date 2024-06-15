//
//  Label.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import UIKit

enum LabelType {
    case head
    case descLine
    case contactTitle
    case contactDesc
    case popupTitle
    case popupDesc
    case navTitle
    case navDashTitle
    case navDesc
    case errorLabel
    case rememberMe
}

struct FormLinkData {
    let text: String
    let url: String?
}

@objc protocol LabelDelegate: AnyObject {
    @objc optional
    func onLinkPressed(text: String, url: String?)
}

class Label: UILabel {
    
    struct Design {
        struct sizes {
            static let size_48: CGFloat = 48.0
            static let size_40: CGFloat = 40.0
            static let size_32: CGFloat = 32.0
            static let size_28: CGFloat = 28.0
            static let size_18: CGFloat = 18.0
            static let size_16: CGFloat = 16.0
            static let size_14: CGFloat = 14.0
            static let size_12: CGFloat = 12.0
            static let size_10: CGFloat = 10.0
        }
        
        struct colors {
            static let titleColor = UIColor.BrandColour.Custom.gunmetal
            static let errorColor = UIColor.BrandColour.Custom.errorCode
            static let whiteColor = UIColor.white
            static let orderTitleColor = UIColor.BrandColour.Custom.gunmetal
            static let orderDescColor = UIColor.BrandColour.Custom.TabGray
            static let orderNoDataTextColor = UIColor.BrandColour.Custom.noDataTextColor
            static let timerCounter = UIColor.BrandColour.Custom.GrayX11
            static let messageColor = UIColor.BrandColour.Custom.workOrderPhotosMessageColor
            static let activeTimer: UIColor = UIColor.BrandColour.Custom.inProgressForeground
            static let mauve3 = UIColor.BrandColour.Custom.TabGray
        }
        
        struct fontName {
            static let name = ""
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
//        super.drawText(in: rect.inset(by: insets)) // have to confirm
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: textRect)
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        return contentSize
    }
    
    func setTheme(_ type: LabelType) {  // swiftlint:disable:this cyclomatic_complexity  function_body_length
        switch type {
        case .head:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_32, alignment: .left, color: Design.colors.titleColor, name: FontName.MontserratBold.rawValue)
        case .contactDesc:
            setCustomTheme(textStyle: .subheadline, fontSize: Design.sizes.size_14, alignment: .left, color: Design.colors.mauve3, name: FontName.MontserratLight.rawValue)
        case .contactTitle:
            setCustomTheme(textStyle: .subheadline, fontSize: Design.sizes.size_18, alignment: .left, color: Design.colors.titleColor, name: FontName.MontserratSemiBold.rawValue)
        case .descLine, .navDesc:
            setCustomTheme(textStyle: .subheadline, fontSize: Design.sizes.size_14, alignment: .left, color: Design.colors.titleColor, name: FontName.MontserratLight.rawValue)
        case .rememberMe:
            setCustomTheme(textStyle: .subheadline, fontSize: Design.sizes.size_12, alignment: .left, color: Design.colors.titleColor, name: FontName.MontserratRegular.rawValue)
        case .errorLabel:
            setCustomTheme(textStyle: .subheadline, fontSize: Design.sizes.size_14, alignment: .left, color: Design.colors.errorColor, name: FontName.MontserratMedium.rawValue)
        case .popupTitle:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_32, alignment: .center, color: Design.colors.titleColor, name: FontName.MontserratBold.rawValue)
        case .popupDesc:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_14, alignment: .center, color: Design.colors.titleColor, name: FontName.MontserratRegular.rawValue)
        case .navTitle:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_32, alignment: .left, color: .red, name: FontName.MontserratBold.rawValue)
        case .navDashTitle:
            setCustomTheme(textStyle: .title1, fontSize: Design.sizes.size_28, alignment: .left, color: Design.colors.titleColor, name: FontName.MontserratBold.rawValue)
        }
    }
    
    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    @objc
    func labelTapped(_ gesture: UITapGestureRecognizer) {
        if let text = self.text, let links = links {
            for link in links {
                let linkRange = (text as NSString).range(of: link.text)
                if gesture.didTapAttributedTextInLabel(label: self, inRange: linkRange) {
                    delegate?.onLinkPressed?(text: link.text, url: link.url)
                }
            }
        }
    }
    
    private func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(labelTap)
    }
    
    private func setFont(fontName: String, fontSize:CGFloat, fontWeight: CGFloat) {
        font = UIFont(name: fontName, size: fontSize)
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
        textColor = enabled ? color : Design.colors.titleColor
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
    
    func addedStarWithTextTitle(strTitle: String) -> NSAttributedString {
        let passwordAttriburedString = NSMutableAttributedString(string: strTitle)
        let asterix = NSAttributedString(string: " *", attributes: [.foregroundColor: UIColor.red])
        passwordAttriburedString.append(asterix)
        return passwordAttriburedString
    }
}
