//
//  SplashViewModel.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import Foundation
import UIKit
class SplashViewModel {
    private var dictFlags = [String:Any]()
    private var worldCurrencyData = [WorldCurrency]()
}

extension SplashViewModel {
    func isValidParams(params: [String: Any]) -> LatestRatesAPIValidation {
        if let value = params[Params.appID] as? String, value.isEmpty {
            return LatestRatesAPIValidation(message: "App ID should not be empty", isValid: false)
        }
        return LatestRatesAPIValidation(message: "", isValid: true)
    }
}


//MARK: - API calls methods
extension SplashViewModel {
    func callCurrencyRateAPI(_ handler: @escaping(_ responseData: LatestRatesAPI?) -> Void) {
        let params: [String: Any] = [Params.appID:kOpenExchangeRateAppID]
        if isValidParams(params: params).isValid {
            NetworkManager.shared.apiRequest(type: LatestRatesAPI.self, apiName: .latest, method: .getAPI, params: params) { [weak self] responseData in
                guard let strongSelf = self else { return }
                let timestamp = NSDate().timeIntervalSince1970
                UserDefaults.standard.set(timestamp, forKey:  getUserDefaultKey(key: .oldTimestamp))
                strongSelf.setLatestData(data: responseData)
                handler(responseData)
            }
        } else {
            handler(nil)
        }
    }
}

//MARK: - Setter methods
extension SplashViewModel {
    internal func setCountryFlags(fileName: String, format: String) -> Bool {
        if let path = Bundle.main.path(forResource: fileName, ofType: format) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                dictFlags = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String : Any]
                return true
            } catch let error {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func getFlag(countryCode: String) -> String {
        var flag = ""
        if let value = dictFlags[countryCode] as? String {
            flag = value
        } else if let value = dictFlags["NO_IMAGE"] as? String {
            flag = value
        }
        return flag
    }
    
    internal func setLatestData(data: LatestRatesAPI) {
        guard let rates = data.rates else { return }
        let isCountriesRead = setCountryFlags(fileName: kFlagIndices, format: kFIFileFormat)
        let keys = Array(rates.keys)
        let values = Array(rates.values)
        var countryTag = 1
        for (idx, keyName) in keys.enumerated() {
            let countries = CountryMapper.regionNames(currencyCode: keyName)
            for country in countries {
                let exchangeRate = values[idx]
                let countryCode = CountryMapper.getCountryCode(for: country)
                let flag = isCountriesRead ? getFlag(countryCode: countryCode) : "🌍"
                let symbol = CountryMapper.getSymbol(forCurrencyCode: keyName)
                let countryModel = WorldCurrency(countryCurrencyCode: keyName, countryCode: countryCode, countryRate: exchangeRate, countrySymbol: symbol, countryName: country, countryFlag:  flag, tag: countryTag)
                if (worldCurrencyData.filter{ $0.countryName == country }).count == 0 {
                    worldCurrencyData.append(countryModel)
                    setRealmData(data: countryModel)
                    countryTag = countryTag + 1
                }
            }
        }
    }
    
    func setRealmData(data: WorldCurrency) {
        let item = Country()
        item.countryId = data.tag
        item.countryName = data.countryName
        item.countryRate = data.countryRate
        item.countryCode = data.countryCode
        item.countrySymbol = data.countrySymbol
        item.countryFlag = data.countryFlag
        item.countryCurrencyCode = data.countryCurrencyCode
        DBManager.sharedInstance.addData(object: item)
    }
    
    func setFromRealmData() {
        let dbData = getRealmData()
        worldCurrencyData = [WorldCurrency]()
        for data in dbData {
            let model = WorldCurrency(countryCurrencyCode: data.countryCurrencyCode, countryCode: data.countryCode, countryRate: data.countryRate, countrySymbol: data.countrySymbol, countryName: data.countryName, countryFlag: data.countryFlag, tag: data.countryId)
            worldCurrencyData.append(model)
        }
    }
}

//MARK: - Getter methods
extension SplashViewModel {
    func canAPICallAgain() -> Bool {
        guard let prevTimestamp = UserDefaults.standard.object(forKey: getUserDefaultKey(key: .oldTimestamp)) as? Double else { return true }
        let currentTimestamp = NSDate().timeIntervalSince1970
        return Int(currentTimestamp - Double(prevTimestamp)) > 1800
    }
    
    func getAllData() -> [WorldCurrency] {
        return worldCurrencyData
    }

    internal func getRealmData() -> [Country] {
        return Array(DBManager.sharedInstance.getDataFromDB())
    }
    
    func isDataAreAvailable() -> Bool {
        return worldCurrencyData.count > 0
    }
    
    func getErrorData() -> (title: String, message: String) {
        return (title: localizeString("no_data_title"), message: localizeString("no_data_found"))
    }
}
