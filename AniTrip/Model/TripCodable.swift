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

struct NewTrip: Codable {
    var date: Date
    var missions: [String]
    var comment: String
    var totalDistance: String
    var startingAddress: Address
    var endingAddress: Address
    
    func toAddTripFormat() -> AddingTrip {
        AddingTrip(date: self.date.iso8601, missions: self.missions, comment: self.comment, totalDistance: Double(self.totalDistance) ?? 0.0, startingAddress: self.startingAddress, endingAddress: self.endingAddress)
    }
}

struct AddingTrip: Codable {
    let date: String
    let missions: [String]
    let comment: String
    let totalDistance: Double
    let startingAddress: Address
    let endingAddress: Address
}

struct TripChartPoint: Codable, Hashable {
    let date: String
    let distance: Double
}

struct ThisWeekInformations: Codable {
    let distance: Double
    let numberOfTrip: Int
}
