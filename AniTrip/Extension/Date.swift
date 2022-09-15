//
//  Date.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import Foundation

extension Date {
    /// Get the date at the format dd/MM/yyyy
    var dateOnly: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: self)
    }
    
    /// Transform the date to the ISO8601 format
    var iso8601: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.string(from: self)
    }
    
    /// Get the 3 first charachters of the day name
    var dayNameInitials: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return String(dateFormatter.string(from: self).prefix(3))
    }
    
    var getDatePickerRange: ClosedRange<Date> {
        let minValue = Calendar.current.date(byAdding: .year, value: -100, to: self) ?? Date()
        return minValue...self
    }
}
