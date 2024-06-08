//
//  CountryCurrencyView.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import UIKit

protocol CountryCurrencyDelegate: NSObject {
    func onClickDropDown(tag: Int)
    func startEditing()
    func changeValue(text: String)
    func onClickDone()
}

class CountryCurrencyView: UIView {
    internal enum ScreenType: Int {
        case from = 0
        case to
    }
    
    private let stackView = UIStackView()
    private let dropDown = CurrencyDropdownView()
    private let textFieldView = UIView()
    private let textField = TextFieldView()
    private let convertedValue = Label(type: .convertedValue)
    private var type: ScreenType = .from
    weak var delegate: CountryCurrencyDelegate?
    
    struct Design {
        static let zero: CGFloat = 0
        static let spacing: CGFloat = 16
        static let mainViewInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let numberOfLine: Int = 1
    }
    
    init(type: ScreenType = .from) {
        super.init(frame: .zero)
        self.type = type
        setTheme()
        doLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTheme() {
        stackView.do {
            $0.distribution = .fill
            $0.axis = .horizontal
            $0.spacing = Design.spacing
        }
        textField.do {
            $0.setKeyboardType(.decimalPad)
            $0.setTextAlignment(textAlignment: .right)
            $0.delegate = self
        }
        dropDown.do {
            $0.delegate = self
        }
        
        convertedValue.do {
            $0.adjustsFontSizeToFitWidth = true
            $0.sizeToFit()
            $0.numberOfLines = Design.numberOfLine
        }
    }
    
    private func doLayout() {
        textFieldView.addSubview(type == .from ? textField : convertedValue)
        stackView.addArrangedSubviews([dropDown, textFieldView])
        addSubview(stackView)
        stackView.pinTo(self, insets: Design.mainViewInsets)
        if type == .from {
            textField.constrain([
                textField.leftAnchor.constraint(equalTo: textFieldView.leftAnchor, constant: Design.zero),
                textField.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor, constant: Design.zero),
                textField.rightAnchor.constraint(equalTo: textFieldView.rightAnchor, constant: Design.zero)
            ])
        } else {
            convertedValue.constrain([
                convertedValue.leftAnchor.constraint(equalTo: textFieldView.leftAnchor, constant: Design.zero),
                convertedValue.centerYAnchor.constraint(equalTo: textFieldView.centerYAnchor, constant: Design.zero),
                convertedValue.rightAnchor.constraint(equalTo: textFieldView.rightAnchor, constant: Design.zero)
            ])
        }
    }
    
    func setData(data: CountryCurrencyModel) {
        dropDown.setData(data: data.dropdownData)
        if type == .from {
            textField.do {
                $0.setCustomImage(image: generateImageWithText(text: data.currencySymbol))
                if data.value == localizeString("landing_empty_currency_value") {
                    $0.setPlaceHolder(data.value)
                } else {
                    $0.setTextEntered(data.value)
                }
                $0.textField.addDoneCancelToolbar(onDone: (target: self, action: #selector(onClickDone)))
            }
            
        } else {
            convertedValue.setText(data.value)
        }
    }
    
    @objc func onClickDone() {
        textField.resignFirstResponder()
        delegate?.onClickDone()
    }
    
    func generateImageWithText(text: String) -> UIImage? {
        guard let image = UIImage(named: ImageName.icBlank.rawValue) else { return nil }

        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = UIColor.BrandColour.Custom.gunmetal
        label.text = text
        label.sizeToFit()

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageWithText
    }
}

// MARK: -
extension CountryCurrencyView: CurrencyDropdownDelegate {
    func onClickDropdown(tag: Int) {
        delegate?.onClickDropDown(tag: tag)
    }
}

extension CountryCurrencyView: TextFieldViewDelegate {
    
    func formTextFieldEditingDidBegin(textField: TextFieldView) {
        delegate?.startEditing()
    }
    
    func formTextFieldEditingDidEnd(textField: TextFieldView) {
        delegate?.changeValue(text: textField.getTextEntered())
    }
    
    func formTextField(_ textField: TextFieldView, shouldChangeTextIn range: NSRange, replacementString string: String) -> Bool {
        let updatedValue = textField.getTextEntered() + string
        delegate?.changeValue(text: updatedValue)
        return true
    }
}
