//
//  AppController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation

final class AppController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // Loading view
    @Published var loadingInProgress: Bool = false
    var loadingMessage: String = ""
    
    // Alert view
    @Published var showAlertView: Bool = false
    var alertViewMessage: String = ""
    var mustReturnToPreviousView: Bool = false
    
    // MARK: Methods
    /// Setting loading in progress
    func setLoadingInProgress(withMessage message: String) {
        objectWillChange.send()
        loadingInProgress = true
        loadingMessage = message
    }
    
    /// Reset loading in progress
    func resetLoadingInProgress() {
        objectWillChange.send()
        loadingMessage = ""
        loadingInProgress = false
    }
    
    /// Show an alert view
    func showAlertView(withMessage message: String, mustReturnToPreviousView: Bool = false) {
        objectWillChange.send()
        self.mustReturnToPreviousView = mustReturnToPreviousView
        resetLoadingInProgress()
        alertViewMessage = message
        showAlertView = true
    }
    
    /// Reset alert view
    func resetAlertView() {
        objectWillChange.send()
        mustReturnToPreviousView = false
        alertViewMessage = ""
        showAlertView = false
    }
    
    // MARK: Initialization
    init() {
        // Configure general notifications
        configureNotification(for: Notification.AniTrip.unknownError.notificationName)
        configureNotification(for: Notification.AniTrip.accountNotYetActivate.notificationName)
        configureNotification(for: Notification.AniTrip.notAuthorized.notificationName)
        configureNotification(for: Notification.AniTrip.accountNotFound.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            objectWillChange.send()
            self.resetLoadingInProgress()
            
            switch notificationName {
            case Notification.AniTrip.unknownError.notificationName,
                Notification.AniTrip.accountNotYetActivate.notificationName,
                Notification.AniTrip.notAuthorized.notificationName,
                Notification.AniTrip.accountNotFound.notificationName:
                self.showAlertView(withMessage: notificationMessage)
            default: break
            }
        }
    }
}
