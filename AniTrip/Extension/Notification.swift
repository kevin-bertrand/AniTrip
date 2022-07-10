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
        
        // Login notifications
        case loginSuccess = "Successfull login!"
        case loginWrongCredentials = "Your credentials are not correct!"
        case loginAccountNotActivate = "Your account is not activate yer!"
        
        var notificationName: Notification.Name {
            return Notification.Name(rawValue: "\(self)")
        }
        
        var notificationMessage: String {
            return self.rawValue
        }
        
        func sendNotification() {
            let notificationBuilder = Notification(name: notificationName, object: self, userInfo: ["name": self.notificationName, "message": self.notificationMessage])
            NotificationCenter.default.post(notificationBuilder)
        }
    }
}
