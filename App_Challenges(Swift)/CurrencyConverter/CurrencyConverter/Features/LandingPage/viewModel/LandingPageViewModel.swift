//
//  LandingPageViewModel.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import Foundation

class LandingPageViewModel {
    private var worldCurrencyData = [WorldCurrency]()
    private var fromCurrency: WorldCurrency = WorldCurrency()
    private var toCurrency: WorldCurrency = WorldCurrency()
    private var screenData: LandingPageModel = LandingPageModel()
    private var viewType: CurrencyType = .none
    
    internal enum CurrencyType: Int {
        case from = 0
        case to
        case none
    }
    
    internal enum RowType: Int {
        case currencyView = 0
        case convertButton
        case totalRows
    }
}

//MARK: - Setter methods
extension LandingPageViewModel {
    
    func setData(data: [WorldCurrency]) {
        worldCurrencyData = data
        
        let froRowTag = worldCurrencyData.filter { $0.countryCode == "IN" }.last?.tag ?? 0
        let toRowTag = worldCurrencyData.filter { $0.countryCode == "JP" }.last?.tag ?? 0
        
        setSelectedCurrency(row: froRowTag, type: .from)
        setSelectedCurrency(row: toRowTag, type: .to)
    }
    
    func setSelectedCurrency(row: Int, type: CurrencyType) {
        let value = worldCurrencyData[row - 1]
        switch type {
        case .from:
            fromCurrency = value
            setFromData()
        case .to:
            toCurrency = value
            setToData()
        case .none:
            break
        }
    }
    
    func setFromData() {
        let fullText = "\(fromCurrency.countryFlag) \(fromCurrency.countryName)"
        let dropdownModel = CurrencyDropdownModel(index: 0, title: fullText, currencyCode: fromCurrency.countryCurrencyCode)
        let prevValue = screenData.from.value.isEmpty ? "0.00" : screenData.from.value
        let model = CountryCurrencyModel(dropdownData: dropdownModel, value: prevValue, currencySymbol: fromCurrency.countrySymbol)
        screenData.from = model
        setToData()
    }
    
    func setToData() {
        let fullText = "\(toCurrency.countryFlag) \(toCurrency.countryName)"
        let toDropdownModel = CurrencyDropdownModel(index: 1, title: fullText, currencyCode: toCurrency.countryCurrencyCode)
        let toModel = CountryCurrencyModel(dropdownData: toDropdownModel, value: "\(toCurrency.countrySymbol) \(calculateValues())", currencySymbol: toCurrency.countrySymbol)
        screenData.to = toModel
    }
    
    func setViewType(tag: Int) {
        viewType = CurrencyType(rawValue: tag) ?? .none
    }
    
    func setFromValue(value: String) {
        screenData.from.value = value
        screenData.to.value = "\(toCurrency.countrySymbol) \(calculateValues())".trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func calculateValues() -> String {
        let value1 = fromCurrency.countryRate
        let value2 = toCurrency.countryRate
        let finalValue = (value2 / value1) * (Double(screenData.from.value) ?? 0.0)
        return String(format: "%.2f", finalValue)
    }
    
    func swipeData() {
        let tempCurrencyData = fromCurrency
        fromCurrency = toCurrency
        toCurrency = tempCurrencyData
        screenData.swipe()
        screenData.to.value = "\(toCurrency.countrySymbol) \(calculateValues())".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//MARK: - Getter methods
extension LandingPageViewModel {
    func getTotalRows() -> Int {
        return RowType.totalRows.rawValue
    }
    
    func getScreenData() -> LandingPageModel {
        return screenData
    }
    
    func getViewType() -> CurrencyType {
        return viewType
    }
    
    func getAllData() -> [WorldCurrency] {
        return worldCurrencyData
    }
    
    func getRowType(index: Int) -> RowType {
        return RowType(rawValue: index) ?? .currencyView
    }
    
    func getButton() -> ButtonModel {
        return ButtonModel(title: localizeString("landing_button_convert"))
    }
    
    func getTitle() -> String {
        return localizeString("landing_title")
    }
}
