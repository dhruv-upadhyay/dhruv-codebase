//
//  Common.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 18/04/25.
//

import UIKit

public func sectionHeaderToTopOfDevice() -> CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        if let window = windowScene.windows.first {
            return window.safeAreaInsets.top
        }
    }
    return 0.0
}
