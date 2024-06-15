//
//  Window.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

extension UIWindow {
    
    class func getKeyWindow() -> UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .first(where: { $0.isKeyWindow })
        return keyWindow
    }
    
    class func getSceneDelegate () -> SceneDelegate? {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.delegate as? SceneDelegate
        
        return sceneDelegate
    }
}
