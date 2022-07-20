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

        networkManager.request(urlParams: NetworkConfigurations.getVolunteersList.urlParams, method: NetworkConfigurations.getVolunteersList.method, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let volunteers = try? JSONDecoder().decode([Volunteer].self, from: data) {
                self.volunteersList = volunteers
                Notification.AniTrip.gettingVolunteersListSuccess.sendNotification()
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
    func activate(account: Volunteer, byUser user: User) {
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
    
    // MARK: Private
    // MARK: Properties
    private let networkManager = NetworkManager()
    
    // MARK: Methods
}
