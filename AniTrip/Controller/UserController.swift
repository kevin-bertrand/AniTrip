//
//  UserController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import Foundation
import LocalAuthentication
import Mixpanel
import SwiftUI

final class UserController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    // General properties
    @AppStorage("aniTripDeviceToken") var deviceToken: String = ""
    @Published var isConnected: Bool = false
    var appController: AppController
    var connectedUser: User? { userManager.connectedUser }
    
    // Login view properties
    @AppStorage("anitripSavedEmail") var savedEmail: String = ""
    @AppStorage("anitripSavedPassword") var savedPassword: String = ""
    @AppStorage("anitripCanUseBiometric") var canUseBiometric: Bool = true {
        didSet {
            if canUseBiometric {
                activateBiometric()
            } else {
                savedPassword = ""
            }
        }
    }
    @Published var loginShowBiometricAlert: Bool = false
    @Published var loginSaveEmail: Bool = false
    @Published var loginEmailTextField: String = ""
    @Published var loginPasswordTextField: String = ""
    @Published var loginErrorMessage: String = ""
    
    // Create a new account
    @Published var createAccountEmailTextField: String = ""
    @Published var createAccountPasswordTextField: String = ""
    @Published var createAccountPasswordVerificationTextField: String = ""
    @Published var createAccountErrorMessage: String = ""
    
    // Update user
    @Published var userToUpdate: UserToUpdate = UserToUpdate(firstname: "", lastname: "", email: "", phoneNumber: "", gender: .notDeterminded, position: .user, missions: [], address: LocationController.emptyAddress, password: "", passwordVerification: "")
    @Published var successUpdate: Bool = false
    @Published var showUpdateProfileImage: Bool = false
        
    // MARK: Methods
    /// Check if the email must be saved
    func checkSaveEmail() {
        if loginSaveEmail {
            savedEmail = loginEmailTextField
        } else {
            savedEmail = ""
        }
    }
    
    /// Getting biometrics status to know if it is active
    func getBiometricStatus() -> Bool {        
        if savedEmail == loginEmailTextField && savedPassword.isNotEmpty && appController.isBiometricAvailable {
            return true
        }
        
        return false
    }
    
    /// Perfom login
    func performLogin() {
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
        
        userManager.login(user: UserToLogin(email: loginEmailTextField, password: loginPasswordTextField, deviceToken: deviceToken))
    }
    
    /// Login with biometrics
    func loginWithBiometrics() {
        var error: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Need access to \(laContext.biometryType == .faceID ? "FaceId" : "TouchId") to authenticate to the app."
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.loginPasswordTextField = self.savedPassword
                        self.performLogin()
                    } else {
                        Mixpanel.mainInstance().track(event: "Unable to access biometrics")
                    }
                }
            }
        }
    }
    
    /// Create an account
    func createAccount() {
        appController.setLoadingInProgress(withMessage: "Account creation in progress...")
        loginErrorMessage = ""
        
        guard createAccountEmailTextField.isNotEmpty && createAccountPasswordTextField.isNotEmpty && createAccountPasswordVerificationTextField.isNotEmpty else {
            createAccountErrorMessage = "An email and a password are required!"
            appController.resetLoadingInProgress()
            return
        }
        
        guard createAccountEmailTextField.isEmail else {
            createAccountErrorMessage = "An valid email is required!"
            appController.resetLoadingInProgress()
            return
        }
        
        userManager.createAccount(for: UserToCreate(email: createAccountEmailTextField,
                                                    password: createAccountPasswordTextField,
                                                    passwordVerification: createAccountPasswordVerificationTextField))
    }
    
    /// Disconnect the user
    func disconnectUser() {
        DispatchQueue.main.async {
            self.userManager.disconnectUser()
            self.loginPasswordTextField = ""
            self.isConnected = false
        }
    }
    
    /// Update connected user
    func updateUser() {
        appController.setLoadingInProgress(withMessage: "Updating in progress...")
        
        guard userToUpdate.password == userToUpdate.passwordVerification else {
            appController.resetLoadingInProgress()
            appController.showAlertView(withMessage: "Both new password must match!", andTitle: "Password error!")
            return
        }
        
        if userToUpdate.phoneNumber.isNotEmpty && !userToUpdate.phoneNumber.isPhone {
            appController.resetLoadingInProgress()
            appController.showAlertView(withMessage: "You must enter a valid phone number!", andTitle: "Phone number error")
            return
        }
        
        userManager.updateUser(userToUpdate)
    }
    
    /// Update user profile image
    func updateImage(_ image: UIImage?) {
        guard let image = image else { return }
        
        userManager.updateUserProfileImage(image)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure login notifications
        configureNotification(for: Notification.AniTrip.loginWrongCredentials.notificationName)
        configureNotification(for: Notification.AniTrip.loginSuccess.notificationName)
        
        // Configure account creation notifications
        configureNotification(for: Notification.AniTrip.accountCreationSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.accountCreationPasswordError.notificationName)
        configureNotification(for: Notification.AniTrip.accountCreationInformationsError.notificationName)
        
        // Configure update profile notifications
        configureNotification(for: Notification.AniTrip.updateProfileSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.updatePictureSuccess.notificationName)
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
            DispatchQueue.main.async {
                self.appController.resetLoadingInProgress()
                
                switch notificationName {
                case Notification.AniTrip.loginSuccess.notificationName:
                    self.actionWhenLoginSuccess()
                case Notification.AniTrip.accountCreationSuccess.notificationName:
                    Mixpanel.mainInstance().track(event: "New account creation")
                    self.createAccountEmailTextField = ""
                    self.createAccountPasswordTextField = ""
                    self.createAccountPasswordVerificationTextField = ""
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Success!")
                case Notification.AniTrip.updateProfileSuccess.notificationName:
                    self.userToUpdate.password = ""
                    self.userToUpdate.passwordVerification = ""
                    self.successUpdate = true
                case Notification.AniTrip.loginWrongCredentials.notificationName,
                    Notification.AniTrip.accountCreationPasswordError.notificationName,
                    Notification.AniTrip.accountCreationInformationsError.notificationName:
                    self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
                case Notification.AniTrip.updatePictureSuccess.notificationName:
                    self.showUpdateProfileImage = false
                default: break
                }
            }
        }
    }
    
    /// Getting biometric authentication to active it
    private func activateBiometric() {
        var error: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Need access to \(laContext.biometryType == .faceID ? "FaceId" : "TouchId") to authenticate to the app."
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.savedEmail = self.loginEmailTextField
                        self.savedPassword = self.loginPasswordTextField
                        self.appController.showAlertView(withMessage: "Biometrics is now active!", andTitle: "Success")
                    } else {
                        Mixpanel.mainInstance().track(event: "Unable to access biometrics")
                    }
                }
            }
        }
    }
    
    /// Perfom action when login success
    private func actionWhenLoginSuccess() {
        DispatchQueue.main.async {
            if self.savedPassword.isEmpty && self.canUseBiometric {
                self.loginShowBiometricAlert = true
            }
            
            if let user = self.connectedUser {
                self.userToUpdate = user.toUpdate()
                
                if self.canUseBiometric {
                    self.savedPassword = self.loginPasswordTextField
                }
                
                Mixpanel.mainInstance().track(event: "Sign up")
            }
            
            self.isConnected = true
        }
    }
}
