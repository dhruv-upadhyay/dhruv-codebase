//
//  SceneDelegate.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 22/04/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let rootVC = HomeVC()
        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("Scene became active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("Scene will resign active")
    }
}
