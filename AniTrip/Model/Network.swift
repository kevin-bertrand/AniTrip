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
    
    var method: HTTPMethod {
        var method: HTTPMethod
        
        switch self {
        case .login:
            method = .post
        }
        
        return method
    }
    
    var urlParams: [String] {
        var params: [String]
        
        switch self {
        case .login:
            params = ["user", "login"]
        }
        
        return params
    }
    
    var body: Encodable? {
        var body: Encodable?
        
        switch self {
        case .login:
            body = nil
        }
        
        return body
    }
}
