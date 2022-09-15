//
//  VolunteersCodable.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation
import SwiftUI

struct DownloadedVolunteer: Codable {
    let imagePath: String?
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

struct Volunteer: Equatable {
    let imagePath: String?
    var image: UIImage?
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    let phoneNumber: String
    let gender: String
    var position: Position
    let missions: [String]
    let address: Address?
    let isActive: Bool
}

struct VolunteerToActivate: Codable {
    let email: String
}

struct VolunteerToUpdatePosition: Codable {
    let email: String
    let position: Position
}
