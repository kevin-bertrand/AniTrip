//
//  Double.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

extension Double {
    var twoDigitPrecision: String {
        return String(format: "%.2f", self)
    }
}
