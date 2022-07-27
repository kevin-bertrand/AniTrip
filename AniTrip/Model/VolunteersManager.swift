//
//  VolunteersManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

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
        
        networkManager.request(urlParams: NetworkConfigurations.getVolunteersList.urlParams, method: NetworkConfigurations.getVolunteersList.method, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] (data, response, error) in
            if let self = self,
               let status = response?.statusCode,
               status == 200,
               let data = data,
               let volunteers = try? JSONDecoder().decode([DownloadedVolunteer].self, from: data) {
                self.downloadVolunteerProfilePicture(volunteers: volunteers)
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Desactivate account
    func desactivate(account: Volunteer, byUser user: User) {
        var params = NetworkConfigurations.desactivateAccount.urlParams
        params.append(account.email)
        
        networkManager.request(urlParams: params, method: NetworkConfigurations.desactivateAccount.method, authorization: .authorization(bearerToken: user.token), body: nil) { data, response, error in
            if let statusCode = response?.statusCode,
               statusCode == 202 {
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
        
        networkManager.request(urlParams: params, method: NetworkConfigurations.activateAccount.method, authorization: .authorization(bearerToken: user.token), body: nil) { data, response, error in
            if let statusCode = response?.statusCode,
               statusCode == 202 {
                Notification.AniTrip.activationSuccess.sendNotification()
            } else {
                Notification.AniTrip.unknownError.sendNotification()
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
    
    //
    private func downloadVolunteerProfilePicture(volunteers: [DownloadedVolunteer]) {
        self.volunteersList = []
        
        for (index, volunteer) in volunteers.enumerated() {
            networkManager.downloadProfilePicture(from: volunteer.imagePath, completionHandler: { image in
                self.volunteersList.append(Volunteer(image: image,
                                                     id: volunteer.id,
                                                     firstname: volunteer.firstname,
                                                     lastname: volunteer.lastname,
                                                     email: volunteer.email,
                                                     phoneNumber: volunteer.phoneNumber, gender: volunteer.gender, position: volunteer.position, missions: volunteer.missions, address: volunteer.address, isActive: volunteer.isActive))
                if volunteers.count-1 == index {
                    Notification.AniTrip.gettingVolunteersListSuccess.sendNotification()
                }
            })
        }
    }
}
