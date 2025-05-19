//
//  SearchBarView.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 18/04/25.
//


import UIKit

class SearchBarView: UIView {
    // MARK: - UI Component
    private let textField = UITextField()
    
    // MARK: - Constants
    private let spacing = Constants.Spacing()
    private let fontSize = Constants.FontSize()
    private let color = Constants.Colors()
    private let strings = Constants.Strings()
    
    // MARK: - Callbacks
    var onSearchTextChanged: ((String) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTheme()
        doLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setTheme()
        doLayout()
    }

    // MARK: - Setup View
    private func setTheme() {
        textField.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.placeholder = strings.search
            $0.textColor = .white
            $0.backgroundColor = .clear
            $0.layer.borderWidth = spacing.xs
            $0.layer.cornerRadius = spacing.sm
            $0.layer.borderColor = color.searchColor.cgColor
            $0.delegate = self
            
            $0.attributedPlaceholder = NSAttributedString(
                string: strings.search,
                attributes: [.foregroundColor: color.searchColor]
            )
            $0.setLeftPadding(spacing.m)
        }
    }
    
    private func doLayout() {
        addSubview(textField)
        textField.pinTo(self)
        textField.constrain([
            .height(constant: spacing.xxl)
        ])
    }
    
    // MARK: - Update view
    func setFirstResponder() {
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension SearchBarView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        onSearchTextChanged?(newText)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
