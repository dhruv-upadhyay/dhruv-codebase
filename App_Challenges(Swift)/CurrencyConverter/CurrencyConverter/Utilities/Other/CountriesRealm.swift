//
//  CountriesRealm.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 06/03/23.
//

import Foundation
import RealmSwift

class Country: Object {
    @objc dynamic var countryId: Int = 1
    @objc dynamic var countryCurrencyCode: String = ""
    @objc dynamic var countryCode: String = ""
    @objc dynamic var countryRate: Double = 0.0
    @objc dynamic var countrySymbol: String = ""
    @objc dynamic var countryName: String = ""
    @objc dynamic var countryFlag: String = ""
    
    override static func primaryKey() -> String? {
        return "countryId"
    }
    
}
