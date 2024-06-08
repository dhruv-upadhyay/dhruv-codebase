//
//  LandingPageView.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import UIKit

protocol LandingPageDelegate: NSObject {
    func onClickDropdown(tag: Int)
    func startEditing()
    func changeValue(text: String)
    func onClickSwipe()
    func onClickDone()
}

class LandingPageView: UIView {
    private let mainView = UIView()
    private let stackView = UIStackView()
    private let fromCurrency = CountryCurrencyView()
    private let toCurrency = CountryCurrencyView(type: .to)
    private let switchButton = RoundSwitchButton()
    weak var delegate: LandingPageDelegate?
    
    struct Design {
        static let zero: CGFloat = 0
        static let mainViewInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        static let spacing16: CGFloat = 16
        static let rightMargin50: CGFloat = -50
        static let cornerRadius16: CGFloat = 16
        static let shadowRadius5: CGFloat = 5
        static let shadowOpacityP13: Float = 0.13
        static let shadowOffsetW1H2: CGSize = CGSize(width: 1, height: 2)
        static let white: UIColor = UIColor.BrandColour.Custom.white
        static let shadowColor: UIColor = UIColor.BrandColour.Custom.gunmetal
        static let backgroundColor: UIColor = UIColor.BrandColour.Custom.viewBackgroundColor
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
        mainView.do {
            $0.backgroundColor = Design.white
            $0.layer.cornerRadius = Design.cornerRadius16
            $0.layer.shadowRadius = Design.shadowRadius5
            $0.layer.shadowOpacity = Design.shadowOpacityP13
            $0.layer.position = .zero
            $0.layer.shadowOffset = Design.shadowOffsetW1H2
            $0.layer.shadowColor = Design.shadowColor.cgColor
        }
        
        stackView.do {
            $0.layer.cornerRadius = Design.cornerRadius16
            $0.clipsToBounds = true
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = Design.spacing16
        }
        
        toCurrency.do {
            $0.backgroundColor = Design.backgroundColor
            $0.delegate = self
        }
        
        fromCurrency.delegate = self
        
        switchButton.delegate = self
    }
    
    private func doLayout() {
        stackView.addArrangedSubviews([fromCurrency, toCurrency])
        mainView.addSubviews([stackView, switchButton])
        addSubview(mainView)
        mainView.pinTo(self, insets: Design.mainViewInsets)
        stackView.pinTo(mainView)
        switchButton.constrain([
            switchButton.centerYAnchor.constraint(equalTo: toCurrency.topAnchor, constant: Design.zero),
            switchButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: Design.rightMargin50)
        ])
    }
    
    func setData(data: LandingPageModel) {
        fromCurrency.setData(data: data.from)
        toCurrency.setData(data: data.to)
    }
}

extension LandingPageView: CountryCurrencyDelegate {
    func onClickDone() {
        delegate?.onClickDone()
    }
    
    func startEditing() {
        delegate?.startEditing()
    }
    
    func changeValue(text: String) {
        delegate?.changeValue(text: text)
    }
    
    func onClickDropDown(tag: Int) {
        delegate?.onClickDropdown(tag: tag)
    }
}

extension LandingPageView: RoundSwitchButtonDelegate {
    func onClickSwipe() {
        delegate?.onClickSwipe()
    }
}
