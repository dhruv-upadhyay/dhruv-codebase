//
//  TextField.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import UIKit

class TextField: UITextField {
    
    struct Design {
        static let fontSize: CGFloat = 14.0
        static let borderWidth: CGFloat = 0
        static let textColor = UIColor.BrandColour.Custom.gunmetal
        static let placeHolderColor = UIColor.BrandColour.Custom.placeHolderColor
        static let errorBgColor = UIColor.BrandColour.Custom.textFieldBackground
        static let errorBorderColor = UIColor.BrandColour.Border.errorBorder
        static let validBgColor = UIColor.BrandColour.Custom.textFieldBackground
        static let height: CGFloat = 48.0
        static let radius: CGFloat = 24.0
    }
    
    var paddingValue: CGFloat = 16
    var paddingLeftValue: CGFloat = 16
    var paddingViewLeftValue: CGFloat = 0
    var paddingViewRightValue: CGFloat = 0
    
    var padding: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: paddingLeftValue, bottom: 0, right: paddingValue)
    }
    
    init() {
        super.init(frame: .zero)
        
        setTheme()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        font = UIFont.customFont(style: .subheadline, size: Design.fontSize)
        textColor = Design.textColor
        validTheme()
        backgroundColor = Design.validBgColor
        layer.borderWidth = Design.borderWidth
        layer.cornerRadius = Design.radius
        autocorrectionType = .no
        clearButtonMode = .never
        heightAnchor.constraint(equalToConstant: Design.height).isActive = true
        
        attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: Design.placeHolderColor])
    }

    func validTheme(valid: Bool = true) {
        layer.borderColor = valid ? nil : Design.errorBorderColor.cgColor
        layer.borderWidth = valid ? 0.0 : Design.borderWidth
    }
    
    func enabled(_ enabled: Bool) {
        isEnabled = enabled
        textColor = enabled ? Design.textColor : Design.placeHolderColor
    }
    
    func setBorderColor(borderColor: UIColor, borderWidth: CGFloat) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var originRect = super.leftViewRect(forBounds: bounds)
        originRect.origin.x += paddingViewLeftValue
        return originRect
    }
}
