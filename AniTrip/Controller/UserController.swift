//
//  UserController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation

final class UserController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    @Published var appController: AppController = AppController()
    @Published var isConnected: Bool = false
    
    // Login view properties
    @Published var loginEmailTextField: String = ""
    @Published var loginPasswordTextField: String = ""
    @Published var loginErrorMessage: String = ""
    
    // MARK: Methods
    /// Perfom login
    func performLogin() {
        objectWillChange.send()
        appController.setLoadingInProgress(withMessage: "Log in... Please wait!")
        loginErrorMessage = ""
        
        guard loginEmailTextField.isNotEmpty && loginPasswordTextField.isNotEmpty else {
            loginErrorMessage = "A password and an email are needed!"
            appController.resetLoadingInProgress()
            return
        }
        
        guard loginEmailTextField.isEmail else {
            loginErrorMessage = "A valid email address is required!"
            appController.resetLoadingInProgress()
            return
        }
        
        userManager.login(user: UserToLogin(email: loginEmailTextField, password: loginPasswordTextField))
    }
    
    // MARK: Initialization
    init() {
        // Configure general notifications
        configureNotification(for: Notification.AniTrip.unknownError.notificationName)
        
        // Configure login notifications
        configureNotification(for: Notification.AniTrip.loginWrongCredentials.notificationName)
        configureNotification(for: Notification.AniTrip.loginSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.loginAccountNotActivate.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let userManager: UserManager = UserManager()
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            appController.resetLoadingInProgress()
            objectWillChange.send()
            
            switch notificationName {
            case Notification.AniTrip.loginSuccess.notificationName:
                self.isConnected = true
            case Notification.AniTrip.unknownError.notificationName,
                Notification.AniTrip.loginAccountNotActivate.notificationName,
                Notification.AniTrip.loginWrongCredentials.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage)
            default: break
            }
        }
    }
}
