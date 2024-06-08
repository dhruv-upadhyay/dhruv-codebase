//
//  TextField.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation
import UIKit

extension UITextField {
    
    // MARK: Add Toolbar
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let showCancel = onCancel != nil
        let showDone = onDone != nil
        
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
      
        let toolbar: UIToolbar = UIToolbar()
        toolbar.items = []
        if showCancel {
            toolbar.items?.append(UIBarButtonItem(title: localizeString("toolbar_cancel"), style: .plain, target: onCancel.target, action: onCancel.action))
        }
        toolbar.items?.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        
        if showDone {
            toolbar.items?.append(UIBarButtonItem(title: localizeString("toolbar_done"), style: .done, target: onDone.target, action: onDone.action))
        }

        toolbar.barStyle = .default
        toolbar.tintColor = .black
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    func enableDoneButton(_ with: Bool) {
        
        guard let toolBar = self.inputAccessoryView as? UIToolbar else {
            return
        }
        
        let doneButton = toolBar.items?.last
        doneButton?.isEnabled = with
    }

    // MARK: Default Actions
    @objc
    func doneButtonTapped() {
        self.resignFirstResponder()
    }
    
    @objc
    func cancelButtonTapped() {
        self.resignFirstResponder()
    }
}
