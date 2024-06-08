//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Dhruv Upadhyay on 04/03/23.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class NetworkManager {
    
    // MARK: - Singleton object
    static let shared = NetworkManager()
    private let baseURL = "https://openexchangerates.org/api/"
    
    // MARK: - Common api Request
    
    func apiRequest<T:Decodable>(type:T.Type, apiName:APIs, method:APIMethods, params:[String:Any],_ handler: @escaping(_ sender:T) -> Void) {
        
        if !(Connectivity.isConnectedToInternet) {
            showErrorPopup(title: "Error", message: "Internet not found!")
            return
        }
        
        var request:URLRequest!
        let headerToken = ""
        
        switch method {
        case .getAPI:
            var apiURL = ""
            apiURL = getAPI(endPoint: apiName.rawValue, params: params)
            var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
            allowedQueryParamAndKey.remove(charactersIn: "+")
            apiURL = apiURL.addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey) ?? ""
            
            guard let url = URL(string:apiURL) else { return }
            request = URLRequest(url: url)
            
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(headerToken)", forHTTPHeaderField: "Authorization")
            
        default:
            let apiURL = getAPI(endPoint: apiName.rawValue, params: ["":""])
            guard let url = URL(string:apiURL) else { return }
            request = URLRequest(url: url)
            guard let jsonString = try? params.toJson() else { return }
            guard let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false) else { return }
            
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(headerToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
        }
        
        AF.request(request).response { [weak self] reseponse in
            
            guard let strongSelf = self else { return }
            
            guard let errorCode = reseponse.response?.statusCode else { return }
            
            let errorCodeType = RequestResponse(rawValue: errorCode)
            
            guard let statusCode = reseponse.response?.statusCode else { return }
            
            let statusCodeType = RequestResponse(rawValue: statusCode)
            if let data = reseponse.data, let debugValue = strongSelf.dataToJSON(data: data) {
                debugPrint("API Name: " + apiName.rawValue)
                debugPrint(debugValue)
            }
            
            if let data = reseponse.request {
                debugPrint(data)
            }
            
            switch errorCodeType {
            case .success200:
                if let data = reseponse.data {
                    do {
                        let userResponse = try JSONDecoder().decode(type, from: data)
                        handler(userResponse)
                    } catch let err {
                        print(err.localizedDescription)
                    }
                }
            
            default:
//                LoadingView.shared.stopAnimation()
                showErrorPopup(title: "Error", message: "Something went wrong!")
                break
            }
        }
    }
    
    private func getAPI(endPoint:String, params:[String:Any]) -> String {
        if params.index(forKey: "") == nil {
            if params.count > 0 {
                let newParamString = "?" + (params.map {"\($0)=\(($1) as! String)"}.joined(separator: "&"))
                return baseURL + endPoint + newParamString
            } else {
                return baseURL + endPoint
            }
        } else {
            return baseURL + endPoint
        }
    }
    
    // MARK: - debug jason
    func dataToJSON(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}

extension Dictionary {
    
    /// Convert Dictionary to JSON string
    /// - Throws: exception if dictionary cannot be converted to JSON data or when data cannot be converted to UTF8 string
    /// - Returns: JSON string
    func toJson() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError(domain: "Dictionary", code: 1, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
}
