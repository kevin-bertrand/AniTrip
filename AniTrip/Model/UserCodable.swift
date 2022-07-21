//
//  UserCodable.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation

struct UserToLogin: Codable {
    let email: String
    let password: String
    let deviceToken: String
}

struct SendDeviceToken: Codable {
    let deviceId: String
}

struct UserToCreate: Codable {
    var email: String
    var password: String
    var passwordVerification: String
}

struct UserToUpdate: Codable {
    var firstname: String
    var lastname: String
    var email: String
    var phoneNumber: String
    var gender: Gender
    var position: Position
    var missions: [String]
    var address: Address
    var password: String
    var passwordVerification: String
}

struct ConnectedUser: Codable {
    let id: String
    let firstname: String
    let lastname: String
    let email: String
    let phoneNumber: String
    let gender: String
    let position: String
    let missions: [String]
    let token: String
    let address: Address?
}

struct User: Codable {
    let id: UUID?
    var firstname: String
    var lastname: String
    let email: String
    var phoneNumber: String
    var gender: Gender
    var position: Position
    var missions: [String]
    var isActive: Bool
    var address: Address?
    var token: String
    
    /// Convert an User to a UserToUpdate structure
    func toUpdate() -> UserToUpdate {
        return UserToUpdate(firstname: self.firstname, lastname: self.lastname, email: self.email, phoneNumber: self.phoneNumber, gender: self.gender, position: self.position, missions: self.missions, address: self.address ?? LocationManager.emptyAddress, password: "", passwordVerification: "")
    }
}

enum Gender: String, Codable {
    case man = "man"
    case woman = "woman"
    case notDeterminded = "not_determined"
}

enum Position: String, Codable, CaseIterable {
    case admin = "administrator"
    case user = "user"
    
    var name: String { rawValue }
}
