//
//  Double.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

extension Double {
    /// Truncate a double to a two digits number 
    var twoDigitPrecision: String {
        return String(format: "%.2f", self)
    }
}
