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
    case updateUser
    
    var method: HTTPMethod {
        var method: HTTPMethod
        
        switch self {
        case .login,
                .createAccount:
            method = .post
        case .updateUser:
            method = .patch
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
        case .updateUser:
            params = ["user"]
        }
        
        return params
    }
}
