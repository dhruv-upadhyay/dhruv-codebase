//
//  UITextField+Extension.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 18/04/25.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
