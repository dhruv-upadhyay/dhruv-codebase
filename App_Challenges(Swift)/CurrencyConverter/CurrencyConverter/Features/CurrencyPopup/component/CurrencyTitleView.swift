//
//  CurrencyTitleView.swift
//  CurrencyConverter
//
// Created by Dhruv Upadhyay on 06/03/23.
//

import UIKit

class CurrencyTitleView: UIView {
    private let mainView = UIView()
    private let stackView = UIStackView()
    private let countryName = Label(type: .popupCountryName)
    private let descLine = Label(type: .popupCountryDesc)
    
    struct Design {
        static let mainViewInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 32)
        static let spacing: CGFloat = 16
        static let highlightColor: UIColor = UIColor.BrandColour.Custom.gunmetal
        static let font: UIFont = UIFont(name: FontName.MontserratMedium.rawValue, size: 14) ?? .systemFont(ofSize: 14)
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
        stackView.do {
            $0.distribution = .fill
            $0.axis = .vertical
            $0.spacing = Design.spacing
        }
    }
    
    private func doLayout() {
        stackView.addArrangedSubviews([countryName, descLine])
        mainView.addSubview(stackView)
        addSubview(mainView)
        mainView.pinTo(self, insets: Design.mainViewInsets)
        stackView.pinTo(mainView)
    }
    
    func setData(data: WorldCurrency) {
        let countryText = "\(data.countryFlag) \(data.countryName)"
        countryName.setText(countryText)
        let descText = localizeString("popup_exchange_rate") + " \(data.countryRate)\n" + localizeString("popup_currency_symbol") + " \(data.countrySymbol)\n" + localizeString("popup_currency_code") + " \(data.countryCurrencyCode)\n" + localizeString("popup_base_usd")
        descLine.setText(descText)
        descLine.setAttributedText(descText, styledStrings: [localizeString("popup_base"), localizeString("popup_exchange_rate"), localizeString("popup_currency_code"), localizeString("popup_currency_symbol")], styledTextColor: Design.highlightColor, styledTextFont: Design.font)
        
    }
}
