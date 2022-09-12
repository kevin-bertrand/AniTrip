//
//  FakeResponseData.swift
//  AniTripTests
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import Foundation
import Alamofire

class FakeResponseData {
    private static let responseOK = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    class ResponseError: Error {}
    static let error = ResponseError()
    
    static func getCorrectData(for dataUrl: DataFiles?, with correctResponse: Response, and dataExtension: DataExtension = .json) -> Data? {
        var data: Data?
        if let dataUrl = dataUrl {
            let bundle = Bundle(for: FakeResponseData.self)
            let url = bundle.url(forResource: dataUrl.rawValue, withExtension: dataExtension.rawValue)
            data = try! Data(contentsOf: url!)
        }
        
        responseData.data = data
        responseData.error = nil
        responseData.response = correctResponse.response
        return data
    }
    
    static var incorrectData: Data {
        get {
            responseData.data = nil
            responseData.response = responseOK
            responseData.error = AFError.explicitlyCancelled
            return "Error".data(using: .utf8)!
        }
    }
    static var responseData = URLResponse()
    
    enum Response {
        case status200
        case status201
        case status202
        case status401
        case status404
        case status406
        case status460
        case status500
        case status0
        
        var response: HTTPURLResponse {
            switch self {
            case .status200:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            case .status201:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            case .status202:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 202, httpVersion: nil, headerFields: nil)!
            case .status401:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            case .status404:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            case .status406:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 406, httpVersion: nil, headerFields: nil)!
            case .status460:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 460, httpVersion: nil, headerFields: nil)!
            case .status500:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            case .status0:
                return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 0, httpVersion: nil, headerFields: nil)!
            }
        }
    }
    
    enum DataFiles: String {
        case userLogin = "login"
        case userNoImage = "loginNoImage"
        case updateUser = "UpdateProfile"
        case volunteerList = "volunteerList"
        case tripList = "trips"
        case threeLatestTrip = "threeLatestsTrips"
        case chartPoints = "chartPoints"
        case news = "news"
        case activationAccount = "activateAccount"
        case desactivateAccount = "desactivateAccount"
        case updatePosition = "updatePosition"
        case export = "export"
        case image = "image"
    }
    
    enum SessionStatus {
        case error
        case correctData
        case incorrectData
    }
    
    struct URLResponse {
        var response: HTTPURLResponse?
        var data: Data?
        var error: Error?
    }
    
    enum DataExtension: String {
        case json = ".json"
        case image = ".jpeg"
    }
}
