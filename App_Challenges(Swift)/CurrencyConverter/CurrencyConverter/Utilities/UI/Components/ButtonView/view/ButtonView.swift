//
//  ButtonView.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import UIKit

protocol ButtonDelegate: NSObject {
    func onClickButton()
}

class ButtonView: UIView {
    struct Design {
        static let buttonInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let buttonHeight: CGFloat = 48
        static let cornerRadius: CGFloat = 24
        static let backgroundColor: UIColor = UIColor.BrandColour.Custom.convertedValueColor
        static let titleColor: UIColor = UIColor.white
        static let font = UIFont(name: FontName.MontserratBold.rawValue, size: 16)
    }
    
    private let button = UIButton()
    private var buttonImage: UIImage?
    weak var delegate: ButtonDelegate?
    
    init() {
        super.init(frame: .zero)
        setTheme()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        button.do {
            $0.backgroundColor = Design.backgroundColor
            $0.setTitleColor(Design.titleColor, for: .normal)
            $0.titleLabel?.font = Design.font
            $0.addTarget(self, action: #selector(onClickButton(sender:)), for: .touchUpInside)
            $0.layer.cornerRadius = Design.cornerRadius
        }
    }
    
    private func doLayout() {
        addSubview(button)
        button.pinTo(self, insets: Design.buttonInsets)
        button.constrain([
            button.heightAnchor.constraint(equalToConstant: Design.buttonHeight)
        ])
    }
    
    @IBAction func onClickButton(sender: UIButton) {
        delegate?.onClickButton()
    }
    
    func setData(data: ButtonModel) {
        button.setTitle(data.title, for: .normal)
    }
}
