//
//  Constants.swift
//  BlueApp
//
//  Created by Dhruv Upadhyay on 16/04/25.
//

import UIKit
import SwiftUI

struct Constants {
    struct Strings {
        let times = "times"
        let search = "Search"
        let jsonFileName = "MediaData"
    }
    
    struct Colors {
        let primaryColor = Color(hex: "#0F1014")
        let lightGray = Color(hex: "#AAB0C1")
        let indicatorColor = Color(hex: "#4B5166")
        let searchColor = Color(hex: "#9EA4B8")
    }
    
    struct Images {
        let icButton = UIImage(named: "ic_button")
        let icShadow = UIImage(named: "ic_shadow")
        let closeIcon = Image(systemName: "xmark")
    }
    
    struct Opacity {
        let low: CGFloat = 0.15
        let medium: CGFloat = 0.6
        let heigh: CGFloat = 0.85
        let full: CGFloat = 1.0
    }
    
    struct Spacing {
        let xs: CGFloat = 1
        let xxs: CGFloat = 2
        let s: CGFloat = 6
        let sm: CGFloat = 8
        let md: CGFloat = 10
        let m: CGFloat = 12
        let ml: CGFloat = 16
        let l: CGFloat = 18
        let lg: CGFloat = 20
        let xl: CGFloat = 30
        let xxl: CGFloat = 36
        let xxxl: CGFloat = 50
        let huge: CGFloat = 61
        let extraHuge: CGFloat = 64
        let giga: CGFloat = 100
        let mega: CGFloat = 108
        let ultra: CGFloat = 150
        let ultraMega: CGFloat = 465
    }
    
    struct FontSize {
        let body: CGFloat = 13
        let mediumTitle: CGFloat = 18
        let title: CGFloat = 32
        let largeTitle: CGFloat = 36
    }
}
