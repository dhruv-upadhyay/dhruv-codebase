//
//  CountryMapperTests.swift
//  CurrencyConverterTests
//
//  Created by Dhruv Upadhyay on 07/03/23.
//

import XCTest
@testable import CurrencyConverter

final class CountryMapperTests: XCTestCase {
    
    func test_get_symbol_validationSuccess() {
        let result = CountryMapper.getSymbol(forCurrencyCode: "INR")
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "₹")
    }
    
    func test_get_symbol_validationFailure() {
        let result = CountryMapper.getSymbol(forCurrencyCode: "USD")
        print(result)
        XCTAssertNotEqual(result, "₹")
    }
    
    func test_get_symbol_empty_validationFailure() {
        let result = CountryMapper.getSymbol(forCurrencyCode: "IN")
        XCTAssertEqual(result, "")
    }
    
    func test_get_country_code_validationSuccess() {
        let result = CountryMapper.getCountryCode(for: "Japan")
        print(result)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, "JP")
    }
    
    func test_get_country_code_validationFailure() {
        let result = CountryMapper.getCountryCode(for: "Japan")
        print(result)
        XCTAssertNotEqual(result, "IN")
    }
    
    func test_get_country_code_empty_validationFailure() {
        let result = CountryMapper.getCountryCode(for: "JPN")
        XCTAssertEqual(result, "")
    }
}
