//
//  LandingPageTests.swift
//  CurrencyConverterTests
//
//  Created by Dhruv Upadhyay on 07/03/23.
//

import XCTest
@testable import CurrencyConverter

final class LandingPageTests: XCTestCase {
    private let splashModel = SplashViewModel()
    private let viewModel = LandingPageViewModel()
    private var arrData = [WorldCurrency]()
    
    override func setUp() {
        test_get_Latest_currency_rates_Success()
        viewModel.setData(data: arrData)
    }
    
    // MARK: - API call
    func test_get_Latest_currency_rates_Success() {
        let expectation = self.expectation(description: "Latest_currency_rates_Success")
        splashModel.callCurrencyRateAPI { [weak self] responseData in
            guard let strongSelf = self else { return }
            guard let data = responseData else { return }
            strongSelf.splashModel.setLatestData(data: data)
            strongSelf.arrData = strongSelf.splashModel.getAllData()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func test_data_count() {
        let result = viewModel.getAllData()
        XCTAssertGreaterThan(result.count, 0)
    }
    
    func test_set_from_value_Success() {
        viewModel.setFromValue(value: "100")
        XCTAssertNotNil(viewModel.getScreenData().to.value)
    }
    
    func test_set_from_empty_value_Failure() {
        viewModel.setFromValue(value: "")
        XCTAssertTrue(viewModel.getScreenData().to.value.contains("0.00"), "Value is empty or not a valid number")
    }
    
    func test_get_screen_data_return_validationFailure() {
        let result = viewModel.getScreenData()
        XCTAssertNotNil(result)
        // From
        XCTAssertNotEqual(result.from.dropdownData.title, "")
        XCTAssertEqual(result.from.dropdownData.index, 0)
        XCTAssertNotEqual(result.from.value, "")

        // To
        XCTAssertNotEqual(result.to.dropdownData.title, "")
        XCTAssertEqual(result.to.dropdownData.index, 1)
    }
    
    func test_swipe_data_Success() {
        viewModel.swipeData()
    }
}
