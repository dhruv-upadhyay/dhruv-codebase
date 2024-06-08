//
//  CurrencyDropdownView.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import UIKit

protocol CurrencyDropdownDelegate: NSObject {
    func onClickDropdown(tag: Int)
}

class CurrencyDropdownView: UIView {
    private let mainView = UIView()
    private let countryName = Label(type: .countryName)
    private let dropdownIcon = UIImageView()
    private let button = UIButton()
    weak var delegate: CurrencyDropdownDelegate?

    struct Design {
        static let zero: CGFloat = 0
        static let size24: CGFloat = 24
        static let size40: CGFloat = 40
        static let margin12: CGFloat = 12
        static let buttonWidth: CGFloat = 150
        static let mainViewInsets: UIEdgeInsets = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        static let numberOfLine: Int = 2
    }
    
    init() {
        super.init(frame: .zero)
        setTheme()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        dropdownIcon.do {
            $0.image = UIImage(named: ImageName.icDropdown.rawValue)
        }
        
        button.addTarget(self, action: #selector(onClickDropdown), for: .touchUpInside)
        
        countryName.do {
            $0.numberOfLines = Design.numberOfLine
            $0.adjustsFontSizeToFitWidth = true
            $0.sizeToFit()
        }
    }
    
    private func doLayout() {
        mainView.addSubviews([countryName, dropdownIcon, button])
        addSubview(mainView)
        mainView.pinTo(self, insets: Design.mainViewInsets)
        button.pinTo(mainView)
        
        countryName.constrain([
            countryName.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: Design.zero),
            countryName.rightAnchor.constraint(equalTo: dropdownIcon.leftAnchor, constant: -Design.margin12),
            countryName.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: Design.zero)
        ])
        
        dropdownIcon.constrain([
            dropdownIcon.heightAnchor.constraint(equalToConstant: Design.size24),
            dropdownIcon.widthAnchor.constraint(equalToConstant: Design.size24)
        ])
        dropdownIcon.pinTo(mainView, pinStyle: .right)
        
        button.constrain([
            button.widthAnchor.constraint(equalToConstant: Design.buttonWidth)
        ])
    }
    
    func setData(data: CurrencyDropdownModel) {
        countryName.setText(data.title)
        tag = data.index
    }
}

// MARK: - Action button
extension CurrencyDropdownView {
    @IBAction func onClickDropdown(sender: UIButton) {
        delegate?.onClickDropdown(tag: self.tag)
    }
}
