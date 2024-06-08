//
//  LocalSaveManager.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation

class LocalSaveManager {
    class func getStringDefaults(key: UserDefaultKeys) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    class func getBoolDefaults(key: UserDefaultKeys) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    class func removeDefaults(key: UserDefaultKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    class func setDefaults(key: UserDefaultKeys, value:Any) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
