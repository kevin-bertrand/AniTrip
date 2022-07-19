//
//  AddressCodable.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation

struct Address: Codable {
    var roadName: String
    var streetNumber: String
    var complement: String
    var zipCode: String
    var city: String
    var country: String
}
