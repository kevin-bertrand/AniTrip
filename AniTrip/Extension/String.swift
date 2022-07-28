//
//  String.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation

extension String {
    /// Determine if the string is an email or not
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Determine if the string is a valid phone number
    var isPhone: Bool {
        let phoneRegEx = "^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePredicate.evaluate(with: self)
    }
    
    /// Check if the string is not empty
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    /// Convert a string into a date
    var toDate: Date? {
        var date: Date?
        
        if let convertedDate = ISO8601DateFormatter().date(from: self) {
            date = convertedDate
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            date = formatter.date(from: self)
        }
        return date
    }
    
    /// Convert chart date point to Date
    var chartPointToDate: Date {
        if let date = ISO8601DateFormatter().date(from: self) {
            return date
        } else {
            let format = DateFormatter()
            format.dateFormat = "MM/yyyy"
            let date = format.date(from: self)
            
            if let date = date {
                return date
            } else {
                return Date()
            }
        }
    }
}
