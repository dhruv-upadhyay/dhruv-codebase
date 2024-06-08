//
//  LandingPageModel.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import Foundation

struct LandingPageModel {
    var from: CountryCurrencyModel = CountryCurrencyModel()
    var to: CountryCurrencyModel = CountryCurrencyModel()
    
    mutating func swipe() {
        let tempData = from
        from = to
        from.value = tempData.value
        to = tempData
    }
}

struct CurrencyRatesModel {
    var countryName: String = ""
    var currencyCode: String = ""
    var currencyRate: Double = 0.0
    var tag: Int = 0
}
