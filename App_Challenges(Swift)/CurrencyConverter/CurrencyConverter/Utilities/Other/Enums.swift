//
//  Enums.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation

enum FontInputType {
    case label
    case button
    case system
    case small
}

enum FontName: String {
    case MontserratBlack = "Montserrat-Black"
    case MontserratBlackItalic = "Montserrat-BlackItalic"
    case MontserratBold = "Montserrat-Bold"
    case MontserratBoldItalic = "Montserrat-BoldItalic"
    case MontserratExtraBold = "Montserrat-ExtraBold"
    case MontserratExtraBoldItalic = "Montserrat-ExtraBoldItalic"
    case MontserratExtraLight = "Montserrat-ExtraLight"
    case MontserratExtraLightItalic = "Montserrat-ExtraLightItalic"
    case MontserratItalic = "Montserrat-Italic"
    case MontserratLight = "Montserrat-Light"
    case MontserratLightItalic = "Montserrat-LightItalic"
    case MontserratMedium = "Montserrat-Medium"
    case MontserratMediumItalic = "Montserrat-MediumItalic"
    case MontserratRegular = "Montserrat-Regular"
    case MontserratSemiBold = "Montserrat-SemiBold"
    case MontserratSemiBoldItalic = "Montserrat-SemiBoldItalic"
    case MontserratThin = "Montserrat-Thin"
    case MontserratThinItalic = "Montserrat-ThinItalic"
}


enum UIViewPinStyle {
    case top
    case left
    case right
    case bottom
    case center
}

enum SafePosition {
    case top
    case bottom
}

enum ImageName: String {
    case icDropdown = "ic_dropdown"
    case icSwitch = "ic_switch"
    case icClose = "ic_close"
    case icBlank = "ic_blank_white"
    case icLoader = "ic_loader"
    case icLogo = "ic_logo"
}

enum LabelType {
    case head
    case countryName
    case popupCountryName
    case popupCountryDesc
    case errorLabel
    case convertedValue
    case currenciesTitle
}

enum UserDefaultKeys: String {
    case latestData = "latestData"
    case oldTimestamp = "oldTimestamp"
}

enum APIMethods:String {
    case getAPI = "get"
    case postAPI = "post"
    case putAPI = "put"
}

enum APIs:String {
   case latest = "latest.json"
}

enum StatusCode:Int {
    case success_200 = 200
}

enum LoaderType:Int {
    case normal = 0
    case inside
}

enum RequestResponse: Int {
    case success200 = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case tooManyTime = 429
    case serverError = 500
    case noConnection = -1009
    case timeOutError = -1001
}
