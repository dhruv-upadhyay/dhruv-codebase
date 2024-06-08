//
//  Global.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation
import CoreBluetooth
import UIKit


// MARK: - API parameters
let kOpenExchangeRateAppID = "dab5175677c64fe8b239c8fe31c75441"
let kFlagIndices = "flag_indices"
let kFIFileFormat = "json"

// MARK: - Gloabl Methods

func getUserDefaultKey(key:UserDefaultKeys) -> String {
    return key.rawValue
}

func showErrorPopup(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    var rootViewController = UIApplication.shared.windows.first!.rootViewController
    if let navigationController = rootViewController as? UINavigationController {
        rootViewController = navigationController.viewControllers.first
    }
    if let tabBarController = rootViewController as? UITabBarController {
        rootViewController = tabBarController.selectedViewController
    }
    
    rootViewController?.present(alertController, animated: true, completion: nil)
    
    alertController.addAction(UIAlertAction(title: localizeString("alert_button_ok"), style: .default, handler: { action in
    }))
}

struct Params {
    static let appID = "app_id"
}
