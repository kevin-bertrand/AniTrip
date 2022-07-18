//
//  TripCodable.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

struct Trip: Codable {
    let id: UUID
    let date: String
    let missions: [String]
    let comment: String?
    let totalDistance: Double
    let startingAddress: Address
    let endingAddress: Address
}
