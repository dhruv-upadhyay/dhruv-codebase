//
//  Array.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
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
