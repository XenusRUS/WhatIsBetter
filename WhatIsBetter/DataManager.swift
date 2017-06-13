//
//  DataManager.swift
//  WhatIsBetter
//
//  Created by admin on 06.06.17.
//  Copyright © 2017 vadim. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import KeychainSwift

class DataManager: NSObject {
    
    enum errorType {
        case success
        case error
        case noInternetConnection
        case invalidToken
    }
    
    fileprivate static var request : DataRequest! = nil
    
    static let rootUrl : String = "http://127.0.0.1:8000"
    static var access_token : String = ""
    
    class func request(url: String, parameters: Parameters?, completionHandler: @escaping (_ response: NSDictionary?, _ result: errorType, _ error_text: String?, _ code: String?)->()) {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(KeychainSwift().get("token")!)",
        ]
        
        request = Alamofire.request("\(rootUrl)\(url)", method: .get, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let json = value as? NSDictionary {
                    if let result = json.value(forKey: "result") as? String {
                        if (result == "success") {
                            completionHandler(json, .success, nil, nil)
                        } else if let error_text = json.value(forKey: "error_text") as? String, let error_code = json.value(forKey: "code") as? String {
                            completionHandler(nil, .error, error_text, error_code)
                        }
                    } else if let _ = json.value(forKey: "detail") as? String {
                        completionHandler(nil, .invalidToken, nil, nil)
                    }
                }
            case .failure(let error):
                if let err = error as? URLError, err.errorCode == -1009 {
                    // no internet connection
                    print("Нет соединения с сервером")
                    completionHandler(nil, .noInternetConnection, nil, nil)
                } else {
                    // other failures
                    completionHandler(nil, .error, nil, nil)
                }
            }
        }
    }
}
