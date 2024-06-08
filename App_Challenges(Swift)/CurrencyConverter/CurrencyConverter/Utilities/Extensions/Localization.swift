//
//  Localization.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 01/03/23.
//

import Foundation

// MARK: String Localization
public func localizeString(_ stringToLocalize: String) -> String {
    return NSLocalizedString(stringToLocalize, comment: "").precomposedStringWithCanonicalMapping
}

public func localizeStringFromTable(_ stringToLocalize: String, tableName: String) -> String {
    return NSLocalizedString(stringToLocalize, tableName: tableName, comment: "").precomposedStringWithCanonicalMapping
}
