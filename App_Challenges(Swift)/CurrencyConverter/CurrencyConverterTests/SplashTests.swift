//
//  SplashTests.swift
//  CurrencyConverterTests
//
//  Created by Torinit Technologies on 07/03/23.
//

import XCTest
@testable import CurrencyConverter

final class SplashTests: XCTestCase {
    private let viewModel = SplashViewModel()
    private let landingViewModel = LandingPageViewModel()
    private var latestData: LatestRatesAPI?
    
    override func setUp() {
        test_get_Latest_currency_rates_Success()
    }
    
    // MARK: - API call
    func test_get_Latest_currency_rates_Success() {
        let expectation = self.expectation(description: "Latest_currency_rates_Success")
        viewModel.callCurrencyRateAPI { [weak self] responseData in
            guard let strongSelf = self else { return }
            strongSelf.latestData = responseData
            XCTAssertNotNil(strongSelf.latestData)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_set_screen_data_from_API_ValidationSuccess() {
        XCTAssertNotNil(latestData)
        if let data = latestData {
            viewModel.setLatestData(data: data)
            let result = viewModel.getAllData()
            XCTAssertNotNil(result)
        }
    }
    
    func test_empty_appId_return_validationFailure() {
        let params = [Params.appID: ""]
        let result = viewModel.isValidParams(params: params)
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        XCTAssertEqual(result.message, "App ID should not be empty")
    }
    
    func test_empty_appId_return_validationSuccess() {
        let params = [Params.appID: kOpenExchangeRateAppID]
        let result = viewModel.isValidParams(params: params)
        XCTAssertTrue(result.isValid)
        XCTAssertNotNil(result.message)
    }
    
    /// Country Maps setup
    func test_set_country_flags_return_WrongFileNameFailure() {
        let result = viewModel.setCountryFlags(fileName: "flagIndices", format: "json")
        XCTAssertFalse(result)
    }
    
    func test_set_country_flags_return_WrongFormatFailure() {
        let result = viewModel.setCountryFlags(fileName: "flag_indices", format: "xml")
        XCTAssertFalse(result)
    }
    
    func test_set_country_flags_return_Success() {
        let result = viewModel.setCountryFlags(fileName: kFlagIndices, format: kFIFileFormat)
        XCTAssertTrue(result)
    }
    
    func test_get_country_flags_return_Success() {
        let result = viewModel.setCountryFlags(fileName: kFlagIndices, format: kFIFileFormat)
        XCTAssertTrue(result)
        let flag = viewModel.getFlag(countryCode: "IN")
        XCTAssertEqual(flag, "🇮🇳")
    }
    
    func test_get_country_flags_return_Failure() {
        let result = viewModel.setCountryFlags(fileName: kFlagIndices, format: kFIFileFormat)
        XCTAssertTrue(result)
        let flag = viewModel.getFlag(countryCode: "IND")
        XCTAssertNotEqual(flag, "🇮🇳")
    }
    
    func test_get_country_flags_return_No_Image_Succsess() {
        let result = viewModel.setCountryFlags(fileName: kFlagIndices, format: kFIFileFormat)
        XCTAssertTrue(result)
        let flag = viewModel.getFlag(countryCode: "IMG")
        XCTAssertEqual(flag, "🌍")
    }
    
    func test_get_realm_data() {
        let result = viewModel.getRealmData()
        XCTAssertGreaterThan(result.count, 0)
    }
    
    func test_set_realm_data() {
        viewModel.setFromRealmData()
    }
}
