//
//  Object.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation

extension NSObject {
    private struct Association {
        static var associatedKey: Int = 0
    }
    
    func getObject<T>() -> T? {
        if let object = objc_getAssociatedObject(self, &Association.associatedKey) as? T {
            return object
        }
        return nil
    }
    
    func setObject<T>(object: T, policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(self, &Association.associatedKey, object, policy)
    }
    
    func removeObject() {
        objc_setAssociatedObject(self, &Association.associatedKey, nil, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    
    func getObject<T>(key: String) -> T? {
        if let data: [String: AnyObject] = self.getObject() {
            if let object = data[key] as? T {
                return object
            }
        }
        return nil
    }
    
    func setObject<T>(object: T, key: String, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        var data: [String: AnyObject] = self.getObject() ?? [String: AnyObject]()
        data[key] = object as AnyObject
        self.setObject(object: data, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func removeObject(key: String) {
        var data: [String: AnyObject] = self.getObject() ?? [String: AnyObject]()
        data.removeValue(forKey: key)
        self.setObject(object: data, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
