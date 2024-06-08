//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Dhruv Upadhyay on 07/03/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterTests: XCTestCase {
    private var arrWorldCurrency = [WorldCurrency]()
    private let viewModel = CurrencyPopupViewModel()
    
    override func setUp() {
        setMockData()
        viewModel.setData(data: arrWorldCurrency)
    }
    
    private func setMockData() {
        let dataOne = WorldCurrency(countryCurrencyCode: "JPY", countryCode: "JP", countryRate: 135.81, countrySymbol: "¥", countryName: "Japan", countryFlag: "🇯🇵", tag: 1)
        
        let dataTwo = WorldCurrency(countryCurrencyCode: "INR", countryCode: "IN", countryRate: 81.83, countrySymbol: "₹", countryName: "India", countryFlag: "🇮🇳", tag: 2)
        
        arrWorldCurrency.append(dataOne)
        arrWorldCurrency.append(dataTwo)
    }
    
    func test_get_data_model_Success() {
        let result = viewModel.getModel(row: 0)
        XCTAssertEqual(result.countryName, "India")
        XCTAssertEqual(result.countrySymbol, "₹")
        XCTAssertEqual(result.countryCode, "IN")
        XCTAssertEqual(result.countryFlag, "🇮🇳")
    }
    
    func test_get_data_model_Failure() {
        let result = viewModel.getModel(row: 0)
        XCTAssertNotEqual(result.countryName, "Japan")
        XCTAssertNotEqual(result.countrySymbol, "¥")
        XCTAssertNotEqual(result.countryCode, "JP")
        XCTAssertNotEqual(result.countryFlag, "🇯🇵")
    }
    
    func test_get_data_empty_model_Failure() {
        let result = viewModel.getModel(row: 2)
        XCTAssertEqual(result.countryName, "")
        XCTAssertEqual(result.countrySymbol, "")
        XCTAssertEqual(result.countryCode, "")
        XCTAssertEqual(result.countryFlag, "")
    }
    
    func test_get_search_model_Failure() {
        viewModel.setSearchData(value: "United states")
        let result = viewModel.getModel(row: 0)
        XCTAssertEqual(result.countryName, "")
        XCTAssertEqual(result.countrySymbol, "")
        XCTAssertEqual(result.countryCode, "")
        XCTAssertEqual(result.countryFlag, "")
    }
    
    func test_get_search_model_Success() {
        viewModel.setSearchData(value: "India")
        let result = viewModel.getModel(row: 0)
        XCTAssertEqual(result.countryName, "India")
        XCTAssertEqual(result.countrySymbol, "₹")
        XCTAssertEqual(result.countryCode, "IN")
        XCTAssertEqual(result.countryFlag, "🇮🇳")
    }
    
    func test_get_option_tag_Success() {
        viewModel.setSearchData(value: "India")
        let countryTag = viewModel.getOptionTag(row: 0)
        XCTAssertEqual(countryTag, 2)
    }
    
    func test_get_option_tag_Failure() {
        viewModel.setSearchData(value: "Japan")
        let countryTag = viewModel.getOptionTag(row: 0)
        XCTAssertNotEqual(countryTag, 2)
    }
    
    func test_get_option_empty_tag_Failure() {
        let countryTag = viewModel.getOptionTag(row: 3)
        XCTAssertNotEqual(countryTag, 2)
    }
    
    func test_get_total_rows_Success() {
        let totalRows = viewModel.getTotalRows()
        XCTAssertEqual(totalRows, arrWorldCurrency.count)
    }
    
    func test_get_total_rows_Failure() {
        let totalRows = viewModel.getTotalRows()
        XCTAssertNotEqual(totalRows, arrWorldCurrency.count + 1)
    }
    
    func test_get_searched_total_rows_Success() {
        viewModel.setSearchData(value: "Japan")
        let totalRows = viewModel.getTotalRows()
        XCTAssertEqual(totalRows, 1)
    }
    
    func test_get_searched_total_rows_Failure() {
        viewModel.setSearchData(value: "United states")
        let totalRows = viewModel.getTotalRows()
        XCTAssertNotEqual(totalRows, 1)
    }
}
