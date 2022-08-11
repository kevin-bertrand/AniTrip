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
    case updatePosition
    case updatePicture
    case getVolunteersList
    case getTripList
    case addTrip
    case updateTrip
    case getThreeLatestTrip
    case getChartPoints
    case getNews
    case activateAccount
    case desactivateAccount
    
    var method: HTTPMethod {
        var method: HTTPMethod
        
        switch self {
        case .login,
                .createAccount,
                .addTrip:
            method = .post
        case .updateUser,
                .updatePosition,
                .activateAccount,
                .desactivateAccount,
                .updatePicture,
                .updateTrip:
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
        case .updateUser:
            params = ["user"]
        case .login:
            params = ["user", "login"]
        case .createAccount:
            params = ["user", "create"]
        case .updatePicture:
            params = ["user", "picture"]
        case .getTripList,
                .addTrip,
                .updateTrip:
            params = ["trip"]
        case .getThreeLatestTrip:
            params = ["trip", "latest"]
        case .getChartPoints:
            params = ["trip", "chart"]
        case .getNews:
            params = ["trip", "news"]
        case .getVolunteersList:
            params = ["volunteers"]
        case .desactivateAccount:
            params = ["volunteers", "desactivate"]
        case .activateAccount:
            params = ["volunteers", "activate"]
        case .updatePosition:
            params = ["volunteers", "position"]
        }
        
        return params
    }
}
