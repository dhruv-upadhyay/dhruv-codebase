//
//  StackView.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

extension UIStackView {
    
    @discardableResult
    func addArrangedSubviews(_ listofViews: [UIView]) -> Self {
        for view in listofViews {
            self.addArrangedSubview(view)
        }
        return self
    }
    
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
    
    func setEnabled(_ enabled: Bool) {
        
        if !enabled {
            let transparentView = UIView(frame: bounds)
            transparentView.tag = 99
            transparentView.backgroundColor = UIColor(white: 1, alpha: 0.6)
            transparentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(transparentView)
        } else {
            let viewToRemove = self.viewWithTag(99)
            viewToRemove?.removeFromSuperview()
        }
    }

    func removeAllSubviews<T: UIView>(subviewClass: T.Type) {
        arrangedSubviews.filter({ $0 is T }).forEach({ $0.removeFromSuperview() })
    }
        
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
        
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
