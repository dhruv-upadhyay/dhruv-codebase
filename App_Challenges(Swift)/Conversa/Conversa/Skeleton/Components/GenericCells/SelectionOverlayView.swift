//
//  ViewDocumnetDetailsViewController.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

class SelectionOverlayView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(hex: 0x000000, alpha: 0.05)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}
