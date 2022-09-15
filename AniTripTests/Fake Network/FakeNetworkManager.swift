//
//  FakeNetworkManager.swift
//  AniTripTests
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import Alamofire
import Foundation
import SwiftUI
@testable import AniTrip

class FakeNetworkManager: NetworkManager {
    private let fakeResponse = FakeResponseData()
    var status: FakeResponseData.SessionStatus = .correctData
    var correctData: FakeResponseData.DataFiles?
    var response: FakeResponseData.Response = .status200
    var correctDataExtension: FakeResponseData.DataExtension = .json
    
    override func request(urlParams: [String],
                          method: Alamofire.HTTPMethod,
                          authorization: Alamofire.HTTPHeader?,
                          body: Encodable?,
                          completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        performRequest(completionHandler: completionHandler)
    }
    
    override func uploadFiles(urlParams: [String],
                              method: Alamofire.HTTPMethod,
                              user: AniTrip.User, file: Data,
                              completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        performRequest(completionHandler: completionHandler)
    }
    
    override func downloadProfilePicture(from path: String?,
                                         completionHandler: @escaping ((UIImage?) -> Void)) {
        switch status {
        case .correctData:
            completionHandler(UIImage(systemName: "gear"))
        case .incorrectData, .error:
            completionHandler(nil)
        }
        
    }
    
    private func performRequest(completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        switch status {
        case .error:
            completionHandler((nil, nil, nil))
        case .incorrectData:
            completionHandler((FakeResponseData.incorrectData,
                               response.response,
                               Alamofire.AFError.responseSerializationFailed(reason: .inputFileNil) as Error))
        case .correctData:
            completionHandler((FakeResponseData.getCorrectData(for: correctData,
                                                               with: response,
                                                               and: correctDataExtension),
                               response.response, nil))
        }
    }
}
