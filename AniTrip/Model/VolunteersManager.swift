//
//  VolunteersManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation
import UIKit

final class VolunteersManager {
    // MARK: Public
    // MARK: Properties
    var volunteersList: [Volunteer] = []
    
    // MARK: Methods
    /// Getting volunteers listing
    func getList(byUser user: User?) {
        guard let user = user else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        networkManager.request(urlParams: NetworkConfigurations.getVolunteersList.urlParams,
                               method: NetworkConfigurations.getVolunteersList.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] (data, response, error) in
            if let self = self,
               let status = response?.statusCode,
               status == 200,
               let data = data,
               let volunteers = try? JSONDecoder().decode([DownloadedVolunteer].self, from: data) {
                let downloadedVolunteersList = volunteers.map({
                    return Volunteer(imagePath: $0.imagePath,
                                     id: $0.id,
                                     firstname: $0.firstname,
                                     lastname: $0.lastname,
                                     email: $0.email,
                                     phoneNumber: $0.phoneNumber,
                                     gender: $0.gender,
                                     position: $0.position == "administrator" ? .admin : .user,
                                     missions: $0.missions,
                                     address: $0.address,
                                     isActive: $0.isActive)
                })

                if self.volunteersList != downloadedVolunteersList {
                    self.volunteersList = downloadedVolunteersList
                    Notification.AniTrip.gettingVolunteersListSuccess.sendNotification()
                }
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Desactivate account
    func desactivate(account: Volunteer, byUser user: User) {
        var params = NetworkConfigurations.desactivateAccount.urlParams
        params.append(account.email)
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.desactivateAccount.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200 {
                self.getList(byUser: user)
                Notification.AniTrip.desactivationSuccess.sendNotification()
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Activate account
    func activate(account: VolunteerToActivate, byUser user: User) {
        var params = NetworkConfigurations.activateAccount.urlParams
        params.append(account.email)
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.activateAccount.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200 {
                self.getList(byUser: user)
                Notification.AniTrip.activationSuccess.sendNotification()
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Changin volunteer position
    func changePosition(of volunteer: VolunteerToUpdatePosition, by user: User?) {
        guard let user = user else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        networkManager.request(urlParams: NetworkConfigurations.updatePosition.urlParams, method: NetworkConfigurations.updatePosition.method, authorization: .authorization(bearerToken: user.token), body: volunteer) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    self.getList(byUser: user)
                    Notification.AniTrip.positionUpdated.sendNotification()
                case 404:
                    Notification.AniTrip.positionNotUpdated.sendNotification()
                default:
                    Notification.AniTrip.unknownError.sendNotification()
                }
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Download volunteer profile picture
    func downlaodProfilePicture(of volunteer: Volunteer, completionHandler: @escaping ((UIImage?)->Void)) {
        if let imagePath = volunteer.imagePath {
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
                    completionHandler(image)
                } else {
                    completionHandler(nil)
                }
            }
        } else {
            completionHandler(nil)
        }
    }
    
    /// Disconnect user
    func disconnect() {
        volunteersList = []
    }
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private let networkManager: NetworkManager
}
