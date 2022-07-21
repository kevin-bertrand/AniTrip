//
//  VolunteersCodable.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

struct Volunteer: Codable {
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    let phoneNumber: String
    let gender: String
    let position: String
    let missions: [String]
    let address: Address?
    let isActive: Bool
}

struct VolunteerToActivate: Codable {
    let email: String
}
