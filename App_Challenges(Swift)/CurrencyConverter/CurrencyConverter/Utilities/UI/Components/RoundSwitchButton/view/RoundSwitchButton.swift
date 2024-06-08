//
//  RoundSwitchButton.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import UIKit

protocol RoundSwitchButtonDelegate: NSObject {
    func onClickSwipe()
}

class RoundSwitchButton: UIView {
    private let mainView = UIView()
    private let subView = UIView()
    private let icon = UIImageView()
    private let button = UIButton()
    weak var delegate: RoundSwitchButtonDelegate?
    
    struct Design {
        static let zero: CGFloat = 0
        static let size50: CGFloat = 50
        static let size36: CGFloat = 36
        static let size25: CGFloat = 25
        static let cornerRadius25: CGFloat = 25
        static let cornerRadius18: CGFloat = 18
        static let shadowRadius5: CGFloat = 5
        static let shadowOpacityP13: Float = 0.30
        static let shadowOffsetW1H2: CGSize = CGSize(width: 1, height: 2)
        static let white: UIColor = UIColor.BrandColour.Custom.white
        static let shadowColor: UIColor = UIColor.BrandColour.Custom.gunmetal
        static let backgroundColor: UIColor = UIColor.BrandColour.Custom.convertedValueColor.withAlphaComponent(0.5)
        static let foregroundColor: UIColor = UIColor.BrandColour.Custom.viewBackgroundColor
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
            $0.backgroundColor = Design.backgroundColor
            $0.layer.cornerRadius = Design.cornerRadius25
        }
        
        subView.do {
            $0.backgroundColor = Design.backgroundColor
            $0.layer.cornerRadius = Design.cornerRadius18
            $0.layer.shadowRadius = Design.shadowRadius5
            $0.layer.shadowOpacity = Design.shadowOpacityP13
            $0.layer.position = .zero
            $0.layer.shadowOffset = Design.shadowOffsetW1H2
            $0.layer.shadowColor = Design.shadowColor.cgColor
        }
        
        subView.backgroundColor = Design.foregroundColor
        icon.image = UIImage(named: ImageName.icSwitch.rawValue)
        button.addTarget(self, action: #selector(onClickSwipe), for: .touchUpInside)
    }
    
    private func doLayout() {
        addSubviews([mainView, subView, icon, button])
        mainView.pinTo(self)
        button.pinTo(self)
        mainView.constrain([
            mainView.heightAnchor.constraint(equalToConstant: Design.size50),
            mainView.widthAnchor.constraint(equalToConstant: Design.size50)
        ])
        icon.constrain([
            icon.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: Design.zero),
            icon.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: Design.zero),
            icon.heightAnchor.constraint(equalToConstant: Design.size25),
            icon.widthAnchor.constraint(equalToConstant: Design.size25)
        ])
        subView.constrain([
            subView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: Design.zero),
            subView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: Design.zero),
            subView.heightAnchor.constraint(equalToConstant: Design.size36),
            subView.widthAnchor.constraint(equalToConstant: Design.size36)
        ])
    }
    
    @IBAction func onClickSwipe(sender: UIButton) {
        delegate?.onClickSwipe()
    }
}
