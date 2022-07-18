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
    
    /// Check if the string is not empty
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    /// Convert a string into a date
    var toDate: Date? {
        ISO8601DateFormatter().date(from: self)
    }
}
