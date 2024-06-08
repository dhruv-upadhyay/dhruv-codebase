//
//  CurrencyPopupViewModel.swift
//  CurrencyConverter
//
// Created by Dhruv Upadhyay on 06/03/23.
//

import Foundation

class CurrencyPopupViewModel {
    private var arrRates = [WorldCurrency]()
    private var searchedData  = [WorldCurrency]()
    private var isSearch: Bool = false
}

// MARK: - Setter methods

extension CurrencyPopupViewModel {
    func setData(data: [WorldCurrency]) {
        arrRates = data.sorted(by: { $0.countryName < $1.countryName})
    }
    
    func setSearchData(value: String) {
        isSearch = !value.isEmpty
        searchedData = arrRates.filter { $0.countryName.contains(value) }
    }
}

extension CurrencyPopupViewModel {
    func getModel(row: Int) -> WorldCurrency {
        let model = isSearch ? searchedData : arrRates
        return model.at(index: row) ?? WorldCurrency()
    }
    
    func getTotalRows() -> Int {
        return isSearch ? searchedData.count : arrRates.count
    }
    
    func getOptionTag(row: Int) -> Int {
        let model = isSearch ? searchedData : arrRates
        return model.at(index: row)?.tag ?? 1
    }
    
    func getTitle() -> String {
        return localizeString("popup_title")
    }
    
    func getPlaceholder() -> String {
        return localizeString("popup_search_country")
    }
}
