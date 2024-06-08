//
//  Array.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation

extension Array {
  
    // safe index access in array
    func at(index: Int) -> Element? {
        if index >= count || index < 0 {
            return nil
        }
        
        return self[index]
    }
}
