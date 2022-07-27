//
//  NetworkManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Alamofire
import Foundation
import SwiftUI

class NetworkManager: NetworkProtocol {
    // MARK: Public
    // MARK: Method
    /// Perform Alamofire request
    func request(urlParams: [String], method: HTTPMethod, authorization: HTTPHeader?, body: Encodable?, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        
        guard let formattedUrl = URL(string: "\(url):\(apiPort)/\(urlParams.joined(separator: "/"))") else {
            completionHandler((nil, nil, nil))
            return
        }
        
        do {
            var headers: HTTPHeaders = [
                .contentType("application/json; charset=utf-8")
            ]
            if let authorization = authorization {
                headers.add(authorization)
            }
            var request = try URLRequest(url: formattedUrl, method: method)
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
            }
            request.headers = headers
            AF.request(request).responseData(completionHandler: { data in
                completionHandler((data.data, data.response, data.error))
            })
        } catch let error {
            print(error.localizedDescription)
            completionHandler((nil, nil, nil))
        }
    }
    
    /// Upload File
    func uploadFiles(urlParams: [String], method: HTTPMethod, user: User, file: Data, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void) {
        guard let formattedUrl = URL(string: "\(url):\(apiPort)/\(urlParams.joined(separator: "/"))") else {
            completionHandler((nil, nil, nil))
            return
        }
        var headers: HTTPHeaders?
        headers = ["Authorization" : "Bearer \(user.token)"]
        
        
        let multiPart: MultipartFormData = MultipartFormData()
        multiPart.append(file, withName: "data", fileName: "filename", mimeType: "image/jpeg" )
        if let filename = "userPicture.jpeg".data(using: .utf8) {
            multiPart.append(filename, withName: "filename")
        }
        AF.upload(multipartFormData: multiPart, to: formattedUrl, method: .patch, headers: headers).response { data in
            print(data)
        }.resume()
    }
    
    /// Download profile picture
    func downloadProfilePicture(from path: String?, completionHandler: @escaping ((UIImage?)->Void)) {
        guard let path = path?.replacingOccurrences(of: "/var/www/html", with: "") else {
            completionHandler(nil)
            return
        }
        
        let imageUrl = url + ":\(imagePort)" + path
        
        guard let imageUrl = URL(string: imageUrl),
              var request = try? URLRequest(url: imageUrl, method: .get) else {
            completionHandler(nil)
            return
        }
        
        request.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
        }.resume()
    }
    
    // MARK: Private
    // MARK: Properties
    private let url = "http://192.168.1.164"
    private let apiPort = 2564
    private let imagePort = 80
}

protocol NetworkProtocol {
    func request(urlParams: [String], method: HTTPMethod, authorization: HTTPHeader?, body: Encodable?, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void)
    
    func uploadFiles(urlParams: [String], method: HTTPMethod, user: User, file: Data, completionHandler: @escaping ((Data?, HTTPURLResponse?, Error?)) -> Void)
    
    func downloadProfilePicture(from path: String?, completionHandler: @escaping ((UIImage?)->Void))
}
