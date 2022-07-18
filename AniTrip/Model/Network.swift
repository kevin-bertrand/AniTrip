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
    case getVolunteersList
    case getTripList
    case addTrip
    case getThreeLatestTrip
    case getChartPoints
    case getNews
    
    var method: HTTPMethod {
        var method: HTTPMethod
        
        switch self {
        case .login,
                .createAccount,
                .addTrip:
            method = .post
        case .updateUser:
            method = .patch
        case .getVolunteersList,
                .getTripList,
                .getThreeLatestTrip,
                .getChartPoints,
                .getNews:
            method = .get
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
        case .updateUser,
                .getVolunteersList:
            params = ["user"]
        case .getTripList,
                .addTrip:
            params = ["trip"]
        case .getThreeLatestTrip:
            params = ["trip", "latest"]
        case .getChartPoints:
            params = ["trip", "chart"]
        case .getNews:
            params = ["trip", "thisWeek"]
        }
        
        return params
    }
}
