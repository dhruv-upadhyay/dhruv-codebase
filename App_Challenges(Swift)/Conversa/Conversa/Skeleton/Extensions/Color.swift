//
//  Color.swift
//  Conversa
//
//  Created by Dhruv Upadhyay on 15/06/24.
//

import Foundation
import UIKit

extension UIColor {

    var hexString: String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
    
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    public convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = UInt8((hex & 0xFF0000) >> 16)
        let g = UInt8((hex & 0xFF00) >> 8)
        let b = UInt8(hex & 0xFF)
        self.init(red8: r, green8: g, blue8: b, alpha: alpha)
    }
    
    public convenience init(red8: UInt8, green8: UInt8, blue8: UInt8, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red8) / 255.0, green: CGFloat(green8) / 255.0, blue: CGFloat(blue8) / 255.0, alpha: alpha)
    }
    
    public func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var (r, g, b, a) = (CGFloat(0.0),
                            CGFloat(0.0),
                            CGFloat(0.0),
                            CGFloat(0.0))
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r, g, b, a)
        }
        return (0.0, 0.0, 0.0, 0.0)
    }
    
    public func components8() -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        var (r, g, b, a) = (CGFloat(0.0),
                            CGFloat(0.0),
                            CGFloat(0.0),
                            CGFloat(0.0))
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (UInt8(r * 255.0), UInt8(g * 255.0), UInt8(b * 255.0), UInt8(a * 255.0))
        }
        return (0, 0, 0, 0)
    }
    
    public func toHex24() -> UInt32 {
        let (r, g, b, a) = self.components8()
        if a != 0 {
            return ((UInt32(r) << 16) | (UInt32(g) << 8) | UInt32(b))
        }
        return 0
    }
    
    public func toHex32() -> UInt32 {
        let (r, g, b, a) = self.components8()
        if a != 0 {
            // If I don't use separate statements.. swift compiler crashes with stupid error about "expression is too complexed to solve..
            
            var result = (UInt32(a) << 24)
            result |= (UInt32(r) << 16)
            result |= (UInt32(g) << 8)
            result |= UInt32(b)
            return result
        }
        return 0
    }
    
    public func toString24() -> String {
        let (r, g, b, a) = self.components8()
        if a != 0 {
            return String(format: "#%02X%02X%02X", Int(r), Int(g), Int(b))
        }
        return String(describing: self)
    }
    
    public func toString32() -> String {
        let (r, g, b, a) = self.components8()
        if a != 0 {
            return String(format: "#%02X%02X%02X%02X", Int(a), Int(r), Int(g), Int(b))
        }
        return String(describing: self)
    }
}
// swiftlint:enable large_tuple

/// Custom Project Colors
extension UIColor {
    struct BrandColour {
        
        struct SplashScreen {
            static let gunmetal = #colorLiteral(red: 0.137254902, green: 0.1960784314, blue: 0.262745098, alpha: 1) // #233243
        }
        
        struct Navigation {
            static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            static let revivalOrange = #colorLiteral(red: 0.9411764706, green: 0.3294117647, blue: 0.137254902, alpha: 1) // #F05423
        }
        
        struct Gray {
            static let gray10 = #colorLiteral(red: 0.01960784314, green: 0.01960784314, blue: 0.01960784314, alpha: 1) // HEX: #050505
            static let gray02 = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1) // #EBEBEB
            static let mauve3 = #colorLiteral(red: 0.7098039216, green: 0.6745098039, blue: 0.7098039216, alpha: 1) // #B5ACB5
            static let navDeviderGray = #colorLiteral(red: 0.9411764706, green: 0.9333333333, blue: 0.9411764706, alpha: 1) // #F0EEF0
            static let checkboxGray = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1) // #D3D3D3
        }
        
        struct shadowColors {
            static let gunmetal15 = #colorLiteral(red: 0.137254902, green: 0.1960784314, blue: 0.262745098, alpha: 0.15) // #233243
            static let gunmetal0 = #colorLiteral(red: 0.137254902, green: 0.1960784314, blue: 0.262745098, alpha: 0) // #233243
        }
        
        struct Custom {
            static let middleBlueGreen = #colorLiteral(red: 0.5568627451, green: 0.8196078431, blue: 0.8039215686, alpha: 1) // #8ED1CD
            static let maximumBlue = #colorLiteral(red: 0.3490196078, green: 0.7098039216, blue: 0.7882352941, alpha: 1) // #59B5C9
            static let moonstoneBlue = #colorLiteral(red: 0.3960784314, green: 0.7490196078, blue: 0.7294117647, alpha: 1) // #65BFBA
            static let gunmetal = #colorLiteral(red: 0.137254902, green: 0.1960784314, blue: 0.262745098, alpha: 1) // #233243
            static let errorCode = #colorLiteral(red: 0.9568627451, green: 0.2862745098, blue: 0.2862745098, alpha: 1) // #F44949
            static let GrayX11 = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1) // #BDBDBD
            static let TabGray = #colorLiteral(red: 0.4588235294, green: 0.4588235294, blue: 0.4588235294, alpha: 1) // #757575
            static let SearchBg = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) // #F5F5F5
            static let noDataTextColor = #colorLiteral(red: 0.7450980392, green: 0.737254902, blue: 0.7450980392, alpha: 1) // #BEBCBE
            static let segmentLine = #colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.937254902, alpha: 1) // #EEEFEF
            
            static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // UIColor(hex: 0xFFFFFF)
            static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            static let red5 = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.3411764706, alpha: 1) // #FF5757
            static let clearColor = UIColor.clear
            
            static let disableMinGrayColor = #colorLiteral(red: 0.7921568627, green: 0.8392156863, blue: 0.8392156863, alpha: 1) // #CAD6D6
            static let disableMaxGrayColor = #colorLiteral(red: 0.5411764706, green: 0.6156862745, blue: 0.662745098, alpha: 1) // #8A9DA9
            
            static let equipmentIconBackground = #colorLiteral(red: 0.937254902, green: 0.9764705882, blue: 0.9725490196, alpha: 1) // #EFF9F8
            
            static let popupYellowStart = #colorLiteral(red: 0.9607843137, green: 0.6862745098, blue: 0.09803921569, alpha: 1) // #F5AF19
            static let popupOrangeEnd = #colorLiteral(red: 0.9529411765, green: 0.4509803922, blue: 0.2078431373, alpha: 1) // #F37335
            
            static let inProgressForeground = #colorLiteral(red: 0.1058823529, green: 0.6117647059, blue: 0.8941176471, alpha: 1) // #1B9CE4
            static let inProgressBackground = #colorLiteral(red: 0.8862745098, green: 0.9568627451, blue: 1, alpha: 1) // #E2F4FF
            
            static let timerValueColor  = #colorLiteral(red: 0.03529411765, green: 0.03529411765, blue: 0.03529411765, alpha: 1) // #090909
            static let searchActiveBorderColor = #colorLiteral(red: 0.3960784314, green: 0.7490196078, blue: 0.7294117647, alpha: 1) // #F44949
            static let searchActiveBackgroundColor = #colorLiteral(red: 0.937254902, green: 0.9764705882, blue: 0.9725490196, alpha: 1) // #EFF9F8
            
            static let workOrderPhotosMessageColor  = #colorLiteral(red: 0.9411764706, green: 0.2705882353, blue: 0.2705882353, alpha: 1) // #F04545
            static let gray5  = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1) // #D9D9D9
            
        }
        
        struct StatusColor {
            static let scheduledForeground = #colorLiteral(red: 0.9490196078, green: 0.6, blue: 0.2901960784, alpha: 1) // #F2994A
            static let scheduledBackground = #colorLiteral(red: 0.9921568627, green: 0.9294117647, blue: 0.9019607843, alpha: 1) // #FDEDE6
            static let inProgressForeground = #colorLiteral(red: 0.1058823529, green: 0.6117647059, blue: 0.8941176471, alpha: 1) // #1B9CE4
            static let inProgressBackground = #colorLiteral(red: 0.8862745098, green: 0.9568627451, blue: 1, alpha: 1) // #E2F4FF
            static let overdueForeground = #colorLiteral(red: 0.9568627451, green: 0.2862745098, blue: 0.2862745098, alpha: 1) // #F44949
            static let overdueBackground = #colorLiteral(red: 0.9960784314, green: 0.9294117647, blue: 0.9294117647, alpha: 1) // #FEEDED
            static let completedForeground = #colorLiteral(red: 0.3960784314, green: 0.7490196078, blue: 0.7294117647, alpha: 1) // #65BFBA
            static let completedBackground = #colorLiteral(red: 0.937254902, green: 0.9764705882, blue: 0.9725490196, alpha: 1) // #EFF9F8
            static let currentlyWorkingForeground = #colorLiteral(red: 0.02745098039, green: 0.6078431373, blue: 0.07843137255, alpha: 1) // #079B14
            static let currentlyWorkingBackground = #colorLiteral(red: 0.02745098039, green: 0.6078431373, blue: 0.07843137255, alpha: 0.1) // #079B14
            static let availableForeground = #colorLiteral(red: 0.9490196078, green: 0.6, blue: 0.2901960784, alpha: 1) // #F2994A
            static let availableBackground = #colorLiteral(red: 0.9490196078, green: 0.6, blue: 0.2901960784, alpha: 0.1) // #F2994A
            static let cancelledForeground  = #colorLiteral(red: 0.9411764706, green: 0.2705882353, blue: 0.2705882353, alpha: 1) // #F04545
            static let cancelledBackground  = #colorLiteral(red: 1, green: 0.9176470588, blue: 0.9176470588, alpha: 1) // #FFEAEA
        }

        struct Shadow {
            static let gray = #colorLiteral(red: 0, green: 0.1333333333, blue: 0.3568627451, alpha: 0.11) // UIColor(hex: 00225B, alpha: 11%)
        }
        
        struct Border {
            static let gray = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2031785103) // rgba(0, 0, 0, 0.2)
        }
    }
}
