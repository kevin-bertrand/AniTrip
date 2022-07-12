//
//  UserManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation

final class UserManager {
    // MARK: Public
    // MARK: Properties
    var connectedUser: User?
    
    // MARK: Methods
    /// Perform the login
    func login(user: UserToLogin) {
        networkManager.request(urlParams: NetworkConfigurations.login.urlParams,
                               method: NetworkConfigurations.login.method,
                               authorization: .authorization(username: user.email, password: user.password),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data {
                switch statusCode {
                case 200:
                    self.decodeLoginData(data)
                case 401:
                    Notification.AniTrip.loginWrongCredentials.sendNotification()
                case 460:
                    Notification.AniTrip.loginAccountNotActivate.sendNotification()
                default:
                    Notification.AniTrip.unknownError.sendNotification()
                }
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Create user account
    func createAccount(for user: UserToCreate) {
        networkManager.request(urlParams: NetworkConfigurations.createAccount.urlParams,
                               method: NetworkConfigurations.createAccount.method,
                               authorization: nil,
                               body: user) { data, response, error in
            if let statusCode = response?.statusCode {
                switch statusCode {
                case 201:
                    Notification.AniTrip.accountCreationSuccess.sendNotification()
                case 406:
                    Notification.AniTrip.accountCreationPasswordError.sendNotification()
                case 500:
                    Notification.AniTrip.accountCreationInformationsError.sendNotification()
                default:
                    Notification.AniTrip.unknownError.sendNotification()
                }
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager = NetworkManager()
    
    // MARK: Methods
    /// Decode login data
    private func decodeLoginData(_ data: Data) {
        if let user = try? JSONDecoder().decode(ConnectedUser.self, from: data),
           let userId = UUID(uuidString: user.id),
           let gender = Gender(rawValue: user.gender),
           let position = Position(rawValue: user.position) {
            connectedUser = User(id: userId,
                                firstname: user.firstname,
                                lastname: user.lastname,
                                email: user.email,
                                phoneNumber: user.phoneNumber,
                                gender: gender,
                                position: position,
                                missions: user.missions,
                                isActive: true,
                                address: user.address ?? Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: ""),
                                token: user.token)
            Notification.AniTrip.loginSuccess.sendNotification()
        } else {
            Notification.AniTrip.unknownError.sendNotification()
        }
    }
}
