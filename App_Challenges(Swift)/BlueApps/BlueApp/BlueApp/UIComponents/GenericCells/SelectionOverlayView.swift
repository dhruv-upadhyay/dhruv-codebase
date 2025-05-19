//
//  ViewDocumnetDetailsViewController.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import Foundation
import UIKit

class SelectionOverlayView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(hex: "#000000")
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
