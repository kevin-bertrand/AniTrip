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
                    if let _ = self.decodeUserInformations(data: data) {
                        Notification.AniTrip.loginSuccess.sendNotification()
                    } else {
                        Notification.AniTrip.unknownError.sendNotification()
                    }
                case 401:
                    Notification.AniTrip.loginWrongCredentials.sendNotification()
                case 460:
                    Notification.AniTrip.accountNotYetActivate.sendNotification()
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
    
    /// Disconnect the user
    func disconnectUser() {
        connectedUser = nil
    }
    
    /// Update connected user
    func updateUser(_ userToUpdate: UserToUpdate) {
        guard let connectedUser = connectedUser else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        networkManager.request(urlParams: NetworkConfigurations.updateUser.urlParams,
                               method: NetworkConfigurations.updateUser.method,
                               authorization: .authorization(bearerToken: connectedUser.token),
                               body: userToUpdate) { data, response, error in
            if let data = data,
               let statusCode = response?.statusCode {
                switch statusCode {
                case 202:
                    if let _ = self.decodeUserInformations(data: data) {
                        Notification.AniTrip.updateProfileSuccess.sendNotification()
                    } else {
                        Notification.AniTrip.unknownError.sendNotification()
                    }
                case 401:
                    Notification.AniTrip.notAuthorized.sendNotification()
                case 406:
                    Notification.AniTrip.accountNotFound.sendNotification()
                case 460:
                    Notification.AniTrip.accountNotYetActivate.sendNotification()
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
    /// Decode user informations
    private func decodeUserInformations(data: Data) -> User? {
        var userInformations: User?
        
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
            userInformations = connectedUser
        }
        
        return userInformations
    }
}
