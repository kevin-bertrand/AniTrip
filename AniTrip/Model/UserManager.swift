//
//  UserManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Alamofire
import Foundation
import SwiftUI

final class UserManager {
    // MARK: Public
    // MARK: Properties
    var connectedUser: User?
    
    // MARK: Methods
    /// Perform the login
    func login(user: UserToLogin) {
        let deviceId = SendDeviceToken(deviceId: user.deviceToken)
        
        networkManager.request(urlParams: NetworkConfigurations.login.urlParams,
                               method: NetworkConfigurations.login.method,
                               authorization: .authorization(username: user.email, password: user.password),
                               body: deviceId) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               let data = data {
                switch statusCode {
                case 200:
                    self.decodeUserInformations(data: data) { user in
                        self.connectedUser = user
                        if user == nil {
                            Notification.AniTrip.unknownError.sendNotification()
                        } else {
                            Notification.AniTrip.loginSuccess.sendNotification()
                        }
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
                               body: userToUpdate) { [weak self] data, response, error in
            if let self = self,
               let data = data,
               let statusCode = response?.statusCode {
                switch statusCode {
                case 202:
                    self.decodeUserInformations(data: data) { user in
                        if user == nil {
                            Notification.AniTrip.unknownError.sendNotification()
                        } else {
                            self.connectedUser = user
                            Notification.AniTrip.updateProfileSuccess.sendNotification()
                        }
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
    
    /// Update user profile image
    func updateUserProfileImage(_ image: UIImage) {
        guard let connectedUser = connectedUser, let imageData = image.jpegData(compressionQuality: 0.9) else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }

        networkManager.uploadFiles(urlParams: NetworkConfigurations.updatePicture.urlParams,
                                   method: NetworkConfigurations.updatePicture.method,
                                   user: connectedUser,
                                   file: imageData) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 202 {
                self.connectedUser?.image = image
                Notification.AniTrip.updatePictureSuccess.sendNotification()
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Getting profile picture
    func getProfilePicture(of user: User, with imagePath: String, completionHandler: @escaping ((User)->Void)) {
        var params = NetworkConfigurations.getProfilePicture.urlParams
        params.append(imagePath)
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.getProfilePicture.method,
                               authorization: nil,
                               body: nil) { data, response, error in
            if let status = response?.statusCode,
               status == 200,
               let data = data,
               let image = UIImage(data: data) {
                var updatedUser = user
                updatedUser.image = image
                completionHandler(updatedUser)
            } else {
                completionHandler(user)
            }
        }
    }
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager: NetworkManager
    
    // MARK: Methods
    /// Decode user informations
    private func decodeUserInformations(data: Data, completionHandler: @escaping ((User?)->Void)) {
        if let user = try? JSONDecoder().decode(ConnectedUser.self, from: data),
           let userId = UUID(uuidString: user.id),
           let gender = Gender(rawValue: user.gender),
           let position = Position(rawValue: user.position) {
            let decodedUser = User(image: nil,
                            id: userId,
                            firstname: user.firstname,
                            lastname: user.lastname,
                            email: user.email,
                            phoneNumber: user.phoneNumber,
                            gender: gender,
                            position: position,
                            missions: user.missions,
                            isActive: true,
                            address: user.address ?? LocationController.emptyAddress,
                            token: user.token)
            if let imagePath = user.imagePath {
                self.getProfilePicture(of: decodedUser, with: imagePath) { user in
                    completionHandler(user)
                }
            } else {
                completionHandler(decodedUser)
            }
        } else {
            completionHandler(nil)
        }
    }
}
