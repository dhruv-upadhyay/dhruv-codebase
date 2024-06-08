//
//  UITableView+Recyclable.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation
import UIKit

extension UITableView {
    
    func cellForRow<T: UITableViewCell>(at indexPath: IndexPath) -> T {
        if let cell = self.cellForRow(at: indexPath) as? T {
            return cell
        }
        fatalError("Cannot Retrieve Cell at IndexPath \(indexPath)")
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        if let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T {
            return cell
        }
        fatalError("Cannot Dequeue Cell With Identifier \(identifier)")
    }
    
    func dequeueReusableView<T: UITableViewHeaderFooterView>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        if let view = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T {
            return view
        }
        fatalError("Cannot Dequeue View With Identifier \(identifier)")
    }
    
    func register<T: UITableViewCell>(cell _: T.Type) {
        let identifier = String(describing: T.self)
        self.register(T.self, forCellReuseIdentifier: identifier)
    }
    
    
    func register<T: UITableViewHeaderFooterView>(view _: T.Type) {
        let identifier = String(describing: T.self)
        self.register(T.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
