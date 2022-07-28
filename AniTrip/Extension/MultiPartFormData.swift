//
//  MultiPartFormData.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 27/07/2022.
//

import Alamofire
import Foundation

extension MultipartFormData {
    /// Append data to multipart
    public func append(_ data: Data, withName name: String, fileName: String, mimeType: String? = nil) {
        let headers = setHeader(withName: name, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        
        append(stream, withLength: length, headers: headers)
    }
    
    /// Set the header of the request
    func setHeader(withName name: String, fileName: String, mimeType: String? = nil) -> HTTPHeaders {
        var disposition = "form-data; name=\"\(name)\""
        disposition += "; filename=\"\(fileName)\""
        
        var headers: HTTPHeaders = [.contentDisposition(disposition)]
        if let mimeType = mimeType { headers.add(.contentType(mimeType)) }
        
        return headers
    }
}
