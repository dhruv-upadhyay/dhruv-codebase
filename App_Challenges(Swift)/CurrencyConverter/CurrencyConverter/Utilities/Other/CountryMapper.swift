//
//  CountryMapper.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 07/03/23.
//

import Foundation

// MARK: - Currency Mapper
struct CountryMapper {
    static let locales = Locale.availableIdentifiers.map(Locale.init)
    static func locales(currencyCode: String) -> Set<Locale> {
        let localesWithCode = self.locales.filter { locale in
            locale.currency?.identifier == currencyCode
        }
        return Set(localesWithCode)
    }
    static func regionNames(currencyCode: String, forLocale locale: Locale = Locale.autoupdatingCurrent) -> [String] {
        let locale = Locale(identifier: locale.identifier)
        let localesForCode = self.locales(currencyCode: currencyCode)
        let names: [String] = localesForCode.compactMap { loc in
            if let regionCode = loc.language.region?.identifier {
                return locale.localizedString(forRegionCode: regionCode)
            } else {
                return locale.localizedString(forIdentifier: loc.identifier)
            }
        }
        return names
    }
    static func getCountryCode(for fullCountryName : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
    static func getSymbol(forCurrencyCode code: String) -> String {
        let locale = NSLocale(localeIdentifier: code)
        let symbol = (locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code) ?? "") as String
        return symbol
    }
}
