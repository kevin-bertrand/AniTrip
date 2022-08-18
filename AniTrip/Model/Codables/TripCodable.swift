//
//  TripCodable.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

struct Trip: Codable, Identifiable {
    let id: UUID
    let date: String
    let missions: [String]
    let comment: String?
    let totalDistance: Double
    let startingAddress: Address
    let endingAddress: Address
    
    func toUpdateTripFormat() -> UpdateTrip {
        UpdateTrip(id: self.id, date: self.date.toDate ?? Date(), missions: self.missions, comment: self.comment ?? "", totalDistance: "\(self.totalDistance)", startingAddress: self.startingAddress, endingAddress: self.endingAddress)
    }
}

struct UpdateTrip: Codable {
    var id: UUID?
    var date: Date
    var missions: [String]
    var comment: String
    var totalDistance: String
    var startingAddress: Address
    var endingAddress: Address
    
    func toAddTripFormat() -> AddingTrip {
        AddingTrip(id: self.id, date: self.date.iso8601, missions: self.missions, comment: self.comment, totalDistance: Double(self.totalDistance) ?? 0.0, startingAddress: self.startingAddress, endingAddress: self.endingAddress)
    }
}

struct AddingTrip: Codable {
    let id: UUID?
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

struct News: Codable {
    let distanceThisWeek: Double
    let numberOfTripThisWeek: Int
    let distanceThisYear: Double
    let numberOfTripThisYear: Int
    let distancePercentSinceLastYear: Double
    let distancePercentSinceLastWeek: Double
    let numberTripPercentSinceLastYear: Double
    let numberTripPercentSinceLastWeek: Double
}

enum ChartFilter: String, Equatable {
    case week = "7 days"
    case month = "1 month"
    case year = "1 year"
}

struct TripFilterToExport: Codable {
    let userID: UUID
    let startDate: String
    let endDate: String
}

struct TripToExportInformations: Codable {
    let userLastname: String
    let userFirstname: String
    let userPhone: String
    let userEmail: String
    let startDate: String
    let endDate: String
    let totalDistance: Double
    let trips: [Trip]
}
