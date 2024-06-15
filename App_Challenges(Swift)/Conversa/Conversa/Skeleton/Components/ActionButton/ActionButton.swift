//
//  ActionButton.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

protocol ActionButtonDelegate: AnyObject {
    func buttonPressed(button: ActionButton)
}

@IBDesignable
public class ActionButton: UIButton {
    public override class var layerClass: AnyClass         { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }
    weak var delegate: ActionButtonDelegate?
    
    @IBInspectable public var startColor: UIColor = UIColor.BrandColour.Custom.middleBlueGreen { didSet { setTheme() } }
    @IBInspectable public var endColor: UIColor = UIColor.BrandColour.Custom.maximumBlue     { didSet { setTheme() } }

    // expose startPoint and endPoint to IB

    @IBInspectable public var startPoint: CGPoint {
        get { gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }

    @IBInspectable public var endPoint: CGPoint {
        get { gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }

    // while we're at it, let's expose a few more layer properties so we can easily adjust them in IB

    @IBInspectable public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable public var borderColor: UIColor? {
        get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }

    // init methods

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setTheme()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTheme()
    }
    
    public override var isEnabled: Bool {
        didSet {
            if let titleLabel = titleLabel {
                if !isEnabled && !((titleLabel.text ?? "").isEmpty) {
                    backgroundColor = .clear
                }
            }
        }
    }
    
    // MARK: - Manage button's title and background color
    
    public func setBackgroundColor(startColor: UIColor, endColor: UIColor, titleColor:UIColor = .white) {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        setTitleColor(titleColor, for: .normal)
    }
    
    public func setTextColor(titleColor: UIColor) {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        setTitleColor(titleColor, for: .normal)
    }
    
    func setFont(fontName: FontName, fontSize: CGFloat) {
        titleLabel?.font = UIFont.customFont(style: .title1, size: fontSize, name: fontName.rawValue)
    }
}

private extension ActionButton {
    func setTheme() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = 11
        titleLabel?.font = UIFont.customFont(style: .title1, size: 16.0, name: FontName.MontserratRegular.rawValue).with(weight: UIFont.Weight(FontWeight.Weight700.rawValue))
        addTarget(self, action: #selector(onButtonPressed(button:)), for: .touchUpInside)
    }
    
    @objc private func onButtonPressed(button: UIButton) {
        delegate?.buttonPressed(button: self)
    }
}
