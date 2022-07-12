//
//  Network.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Alamofire
import Foundation

enum NetworkConfigurations {
    case login
    case createAccount
    
    var method: HTTPMethod {
        var method: HTTPMethod
        
        switch self {
        case .login,
                .createAccount:
            method = .post
        }
        
        return method
    }
    
    var urlParams: [String] {
        var params: [String]
        
        switch self {
        case .login:
            params = ["user", "login"]
        case .createAccount:
            params = ["user", "create"]
        }
        
        return params
    }
}
