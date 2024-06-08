//
//  TextFieldView.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import UIKit
import SDWebImage

@objc
protocol TextFieldViewDelegate: AnyObject {
    @objc
    optional func formTextFieldEditingDidBegin(textField: TextFieldView)
    @objc
    optional func formTextFieldEditingDidEnd(textField: TextFieldView)
    @objc
    optional func formTextFieldEditingChanged(textField: TextFieldView)
    @objc
    optional func formTextField(_ textField: TextFieldView, shouldChangeTextIn range: NSRange, replacementString string: String) -> Bool
    @objc
    optional func formTextFieldShouldReturn(_ textField: TextFieldView) -> Bool
    @objc
    optional func toolBarDonePressed(textField: TextFieldView)
    @objc
    optional func toolBarCancelPressed(textField: TextFieldView)
    @objc
    optional func scrolltoFitTheField(textField: TextFieldView)
    @objc
    optional func setNextFirstResponder(textField: TextFieldView)
    @objc
    optional func onRightViewTouch(textField: TextFieldView)
}

class TextFieldView: UIView {
    struct Design {
        static let beforeAfterFieldSpacing: CGFloat = 8.0
        static let rightViewInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 13.0)
        static let rightViewPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 50)
        static let sideSize: CGFloat = 15.0
        static let errorStatckspacing: CGFloat = 10.0
        static let borderWidth: CGFloat = 0.0
    }
    
    weak var delegate: TextFieldViewDelegate?
    
    private let stackView = UIStackView()

    internal let textField = TextField()
    private var openInput = false
    
    internal let errorLabel = Label(type: .errorLabel)
    
    private var validationRegex: String?
    internal var errorMessage: String?
    private var limit: Int?
    private var key = ""
    private var isRequired: Bool = true
    private var isBackspacing = false
    var paddingValue: CGFloat = 0
    var paddingLeftValue: CGFloat = 16
    var paddingViewLeftValue: CGFloat = 0
    var paddingViewRightValue: CGFloat = 0
    private var imageView = UIImageView()
   
    init() {
        super.init(frame: .zero)
        setTheme()
        doLayout()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setTheme() {
        
        stackView.do {
            $0.alignment = .fill
            $0.distribution = .fill
            $0.axis = .vertical
            $0.setContentHuggingPriority(.defaultLow, for: .vertical)
            $0.spacing = Design.beforeAfterFieldSpacing
        }
        
        textField.do {
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.adjustsFontSizeToFitWidth = true
            $0.delegate = self
            $0.addEventHandler(.editingDidBegin) { [weak self] textField in
                
                if let self = self {
                    self.openInput = true
                    self.setValidationMode(true)
                    self.delegate?.formTextFieldEditingDidBegin?(textField: self)
                }
            }
            $0.addEventHandler(.editingDidEnd) { [weak self] textField in
                
                if let self = self {
                    self.openInput = false
                    self.delegate?.formTextFieldEditingDidEnd?(textField: self)
                }
            }
            $0.addEventHandler(.editingChanged) { [weak self] textField in
                if let self = self {
                    self.delegate?.formTextFieldEditingChanged?(textField: self)
                }
            }
            
        }
        
        errorLabel.do {
            $0.isHidden = true
            $0.adjustsFontSizeToFitWidth = true
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
        
    }
    
    private func doLayout() {
        addSubview(stackView)

        stackView.addArrangedSubviews([textField, errorLabel])
        stackView.pinTo(self)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func setErrorTitle(_ text: String) {
        errorLabel.setText(text)
    }
    
    func setErrorValidation(_ regex: String) {
        validationRegex = regex
    }
    
    func isSecureTextEntry(_ isSecureText: Bool) {
        textField.isSecureTextEntry = isSecureText
    }
    
    func setValidationMode(_ valid: Bool) {
        errorLabel.isHidden = valid
        textField.validTheme(valid: valid)
    }
    
    func setValidationDesign(valid: Bool) {
        textField.validTheme(valid: valid)
    }
    
    func setKeyboardType(_ keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }
    
    func setReturnKeyType (_ returnType: UIReturnKeyType) {
        textField.returnKeyType = returnType
    }
    
    func setTextEntered(_ text: String?) {
        textField.text = text ?? ""
    }
    
    func setTextLimit(_ limit: Int?) {
        self.limit = limit
    }
    
    func setEnabled(_ enabled: Bool = true) {
        textField.enabled(enabled)
    }
    
    func setRequired(_ required: Bool) {
        isRequired = required
    }
    
    func setKey(_ fieldKey: String) {
        key = fieldKey
    }
    
    func setTag(_ tag: Int) {
        self.tag = tag
    }
    
    func getTextEntered() -> String {
        return textField.text ?? ""
    }
    
    func getTextLimit() -> Int? {
        return limit
    }
    
    func getRequired() -> Bool {
        return isRequired
    }
    
    func getValidationRegex() -> String? {
        return validationRegex
    }
    
    func getKey() -> String {
        return key
    }
    
    func getIsBackspacing() -> Bool {
        return isBackspacing
    }
    
    func emptyTextEntered() {
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    func setBackgroundColor(color: UIColor) {
        textField.backgroundColor = color
    }
    
    func setCorners(radius: CGFloat) {

    }
    
    // MARK: Interface Elements Interactions
    func enableClearEditing(_ editingMode: Bool) {
        textField.clearButtonMode = editingMode ? .whileEditing : .never
    }
    
    func enableAutoCorrection(_ enabled: Bool) {
        textField.autocorrectionType = enabled ? .default : .no
    }
    
    func getRightView() -> UIView? {
        return textField.rightView
    }
    
    func setInputView(_ view: UIView?) {
        textField.inputView = view
    }
//
    func setCustomImage(image: UIImage? = nil, _ imageName: String = "", textGap: CGFloat = 14.0, imageGap: CGFloat = 12.0) {
        let leftImage = UIImageView(image: UIImage(named: imageName))
        if image != nil {
            leftImage.image = image
        }
        self.textField.do {
            $0.paddingLeftValue = 45 * self.getAccessibleMultiplier()
            $0.paddingViewLeftValue = imageGap
            $0.leftViewMode = .always
            $0.leftView = leftImage
        }
    }

    func removeLeftView() {
        imageView = UIImageView()
        self.textField.do {
            $0.paddingLeftValue = 12.0
            $0.paddingViewLeftValue = 12.0
            $0.leftViewMode = .never
            $0.leftView = self.imageView
        }
    }
//
    func setCustomRightImage(_ imageName: String, textGap: CGFloat = 14.0, imageGap: CGFloat = 12.0) {
        let rightImage = UIImageView(image: UIImage(named: imageName))
        self.textField.do {
            $0.paddingValue = 45 * self.getAccessibleMultiplier()
            $0.paddingViewRightValue = imageGap
            $0.rightViewMode = .always
            $0.rightView = rightImage
        }
    }

    func removeRightView() {
        imageView = UIImageView()
        self.textField.do {
            $0.paddingLeftValue = 12.0
            $0.paddingViewLeftValue = 12.0
            $0.rightViewMode = .always
            $0.rightView = self.imageView
        }
    }
    
    func setTextAlignment(textAlignment: NSTextAlignment) {
        self.textField.textAlignment = textAlignment
    }
   
    func setPlaceHolder(_ placeHolderText: String?) {
        textField.placeholder = placeHolderText
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if textField.becomeFirstResponder() {
            delegate?.scrolltoFitTheField?(textField: self)
        }
        
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    func setFont(font: UIFont? = nil, errorFont: UIFont? = nil) {
        if let errorFont = errorFont {
            errorLabel.font = errorFont
        }
        
        if let font = font {
            textField.font = font
        }
    }
    
    func setColor(color: UIColor? = nil, labelColor: UIColor? = nil, errorColor: UIColor? = nil) {
        if let errorColor = errorColor {
            errorLabel.color = errorColor
            errorLabel.textColor = errorColor
        }
       
        if let color = color {
            textField.textColor = color
        }
    }
    
    // MARK: ToolBar Textfield Functionalties
    func addDoneCancelToolBar() {
        textField.addDoneCancelToolbar(onDone: (target: self, action: #selector(toolBarDonePressed)), onCancel: (target: self, action: #selector(toolBarCancelPressed)))
    }
    
    @objc
    func toolBarDonePressed() {
        
        resignFirstResponder()
        endEditing(true)
        delegate?.toolBarDonePressed?(textField: self)
    }
    
    @objc
    func toolBarCancelPressed() {
        resignFirstResponder()
        endEditing(true)
        delegate?.toolBarCancelPressed?(textField: self)
    }
    
    // MARK: Validation of Text Entry with Regex
    func validateTextFieldFormat(with regex: String, min limit: Int = 0, with validMode: Bool = false) -> Bool {
        
        if let textEntered = textField.text, !textEntered.isEmpty {
            
            if limit > 0 && textEntered.count != limit {
                if validMode {
                    setValidationMode(false)
                }
                return false
            }
            
            let isValidated = validates(textEntered, with: regex)
            if validMode {
                setValidationMode(isValidated)
            }
            return isValidated
        } else if isRequired {
            if validMode {
                setValidationMode(false)
            }
            return false
        }
        
        if validMode {
            setValidationMode(true)
        }
        return true
    }
    
    // MARK: Validation of Text Entry (Regex, isRequired)
    func validateTextField() -> Bool {
        if let validationRegex = validationRegex, !validationRegex.isEmpty {
            return validateTextFieldFormat(with: validationRegex, min: limit ?? 0)
        }
        
        return validRequired()
    }
    
    func validRequired(with validMode: Bool = false) -> Bool {
        var valid = true
        if isRequired {
            if let textEntered = textField.text, !textEntered.isEmpty {
                if let limit = limit, limit > 0, textEntered.count < limit {
                    valid = false
                }
            } else {
                valid = false
            }
        }
        
        if validMode {
            setValidationMode(valid)
        }
        return valid
    }
    
    func validatePasswordFieldMatch(_ text: String? = nil, with confirmText: String, with validMode: Bool = false) -> Bool {
        var isValidated = false
        if let text = text {
            isValidated = validatesField(text, with: confirmText)
        } else if let textEntered = textField.text, !textEntered.isEmpty {
            isValidated = validatesField(textEntered, with: confirmText)
        }
        
        if validMode {
            setValidationMode(isValidated)
        }
        return isValidated
    }
    
    func validates(_ text: String, with regex: String) -> Bool {
        return text.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func validatesField(_ text: String, with confirmText: String) -> Bool {
        return text == confirmText
    }

    func setErrorMessage(_ errorMessage: String?) {
        guard let errorMessage = errorMessage else {
            return
        }
        
        self.errorMessage = errorMessage
        errorLabel.setText(errorMessage)
        errorLabel.isHidden = errorMessage.isEmpty
        textField.validTheme(valid: errorMessage.isEmpty)
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        get {
            return textField.autocapitalizationType
        }
        set(autocapitalizationType) {
            textField.autocapitalizationType = autocapitalizationType
        }
    }
    
    private func getSecurityTitle(isSecurity: Bool) -> String {
        return isSecurity ? localizeString("generic_show").uppercased() : localizeString("generic_hide").uppercased()
    }
}

// MARK: TextField Delegate
extension TextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty && range.length == 1 {
            isBackspacing = true
        } else {
            isBackspacing = false
        }
        
        return delegate?.formTextField?(self, shouldChangeTextIn: range, replacementString: string) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        endEditing(true)
        
        if textField.returnKeyType == .next {
            DispatchQueue.main.async(execute: { [weak self] in
                guard let self = self, let delegate = self.delegate else {
                    return
                }
                
                delegate.setNextFirstResponder?(textField: self)
            })
        }
        
        return true
    }
}
