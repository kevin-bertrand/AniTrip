//
//  Notification.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation

extension Notification {
    enum AniTrip: String {
        // General notification
        case unknownError = "An unknown error occurs... Try laters!"
        case accountNotYetActivate = "Your account is not activate ye!!"
        case notAuthorized = "You are not authorized to perform this action!"
        case accountNotFound = "An error occurs during the request! Try again!"
        
        // Login notifications
        case loginSuccess = "Successfull login!"
        case loginWrongCredentials = "Your credentials are not correct!"
        
        // Account create notifications
        case accountCreationSuccess = "Your account is created!"
        case accountCreationPasswordError = "Your password don't match!"
        case accountCreationInformationsError = "Your account cannot be created! Verify your informations!"
        
        // Update profile notifications
        case updateProfileSuccess = "Your profile is updated!"
        case updatePictureSuccess = "Your picture is updated!"
        
        // Update position
        case positionUpdated = "The position is updated!"
        case positionNotUpdated = "The position could not be updated!"
        
        // Getting volunteers list
        case gettingVolunteersListSuccess = "Volunteers list downloaded!"
        
        // (Des)activate volunteer account
        case activationSuccess = "The account is activate"
        case desactivationSuccess = "The account is desactivate"
        
        // Getting trip list
        case gettingTripListSucess = "Trips list downloaded!"
        case gettingVolunteerTripListSucess = "Volunteer trip list downloaded!"
        case gettingTripListError = "No trip list found!"
        
        // Adding trip
        case addTripSuccess = "Trip added with success!"
        
        // Downloading home informations
        case homeInformationsDonwloaded = "All informations are downloaded"
        case homeInformationsDonwloadedError = "An error occurs during the download of home informations!"
        
        // Activate account notification
        case showActivateAccount = "A new account must be activate"
        
        /// Getting the name of the notification
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        /// Getting the message of the notification
        var notificationMessage: String {
            return self.rawValue
        }
        
        /// Send the notification throw the NotificationCenter
        func sendNotification() {
            let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": self.notificationName, "message": self.notificationMessage])
            NotificationCenter.default.post(notificationBuilder)
        }
    }
}
