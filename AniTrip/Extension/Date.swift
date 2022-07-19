//
//  Date.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import Foundation

extension Date {
    var dateOnly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
    var iso8601: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: self)
    }
}
