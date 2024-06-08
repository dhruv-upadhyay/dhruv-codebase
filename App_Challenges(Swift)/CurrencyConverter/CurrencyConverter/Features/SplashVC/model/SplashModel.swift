//
//  SplashModel.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import Foundation

struct WorldCurrency {
    var countryCurrencyCode: String = ""
    var countryCode: String = ""
    var countryRate: Double = 0.0
    var countrySymbol: String = ""
    var countryName: String = ""
    var countryFlag: String = ""
    var tag: Int = 0
}

struct LatestRatesAPIValidation {
    var message: String = ""
    var isValid: Bool = false
}

struct LatestRatesAPI : Codable {
    let disclaimer : String?
    let license : String?
    let timestamp : Int?
    let base : String?
    let rates : [String: Double]?
    
    enum CodingKeys: String, CodingKey {
        case disclaimer = "disclaimer"
        case license = "license"
        case timestamp = "timestamp"
        case base = "base"
        case rates = "rates"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        disclaimer = try values.decodeIfPresent(String.self, forKey: .disclaimer)
        license = try values.decodeIfPresent(String.self, forKey: .license)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        
        do {
            rates = try values.decodeIfPresent([String: Double].self, forKey: .rates)
        } catch  _ {
            rates = [String: Double]()
        }
    }
}
