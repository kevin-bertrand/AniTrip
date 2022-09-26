//
//  AppController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation
import LocalAuthentication

final class AppController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // Loading view
    @Published var loadingInProgress: Bool = false
    var loadingMessage: String = ""
    
    // Alert view
    @Published var showAlertView: Bool = false
    var alertViewMessage: String = ""
    var alertViewTitle: String = ""
    
    // Biometric is
    var isBiometricAvailable: Bool {
        let laContext = LAContext()
        return laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none)
    }
    
    // MARK: Methods
    /// Setting loading in progress
    func setLoadingInProgress(withMessage message: String) {
        loadingInProgress = true
        loadingMessage = message
    }
    
    /// Reset loading in progress
    func resetLoadingInProgress() {
        DispatchQueue.main.async {
            self.loadingMessage = ""
            self.loadingInProgress = false
        }
    }
    
    /// Show an alert view
    func showAlertView(withMessage message: String, andTitle title: String) {
        alertViewMessage = message
        alertViewTitle = title
        showAlertView = true
    }
    
    /// Reset alert view
    func resetAlertView() {
        alertViewMessage = ""
        alertViewTitle = ""
    }
    
    /// Disconnect user
    func disconnect() {
        NetworkManager.shared.stopAllRequests()
        resetLoadingInProgress()
        resetAlertView()
    }
    
    // MARK: Initialization
    init() {
        // Configure general notifications
        configureNotification(for: Notification.AniTrip.unknownError.notificationName)
        configureNotification(for: Notification.AniTrip.accountNotYetActivate.notificationName)
        configureNotification(for: Notification.AniTrip.notAuthorized.notificationName)
        configureNotification(for: Notification.AniTrip.accountNotFound.notificationName)
        configureNotification(for: Notification.AniTrip.noInternetConnection.notificationName)
    }
    
    // MARK: Private
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            self.resetLoadingInProgress()
            
            switch notificationName {
            case Notification.AniTrip.unknownError.notificationName,
                Notification.AniTrip.accountNotYetActivate.notificationName,
                Notification.AniTrip.notAuthorized.notificationName,
                Notification.AniTrip.accountNotFound.notificationName,
                Notification.AniTrip.noInternetConnection.notificationName:
                self.showAlertView(withMessage: notificationMessage, andTitle: NSLocalizedString("Error", comment: ""))
            default: break
            }
        }
    }
}
