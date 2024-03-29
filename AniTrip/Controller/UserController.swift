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
    // MARK: Static
    static let emptyUpdateUser = UserToUpdate(firstname: "",
                                              lastname: "",
                                              email: "",
                                              phoneNumber: "",
                                              gender: .notDeterminded,
                                              position: .user,
                                              missions: [],
                                              address: LocationController.emptyAddress,
                                              password: "",
                                              passwordVerification: "")
    
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
    @Published var createAccountPasswordVerification: String = ""
    @Published var createAccountErrorMessage: String = ""
    
    // Update user
    @Published var userToUpdate: UserToUpdate = UserController.emptyUpdateUser
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
        appController.setLoadingInProgress(withMessage: NSLocalizedString("Log in... Please wait!",
                                                                          comment: ""))
        loginErrorMessage = ""
        
        guard loginEmailTextField.isNotEmpty && loginPasswordTextField.isNotEmpty else {
            loginErrorMessage = NSLocalizedString("A password and an email are needed!",
                                                  comment: "")
            let group = DispatchGroup()
            appController.resetLoadingInProgress(group: group)
            return
        }
        
        guard loginEmailTextField.isEmail else {
            loginErrorMessage = NSLocalizedString("A valid email address is required!",
                                                  comment: "")
            let group = DispatchGroup()
            appController.resetLoadingInProgress(group: group)
            return
        }
        
        userManager.login(user: UserToLogin(email: loginEmailTextField.trimmingCharacters(in: .whitespacesAndNewlines),
                                            password: loginPasswordTextField,
                                            deviceToken: deviceToken))
    }
    
    /// Login with biometrics
    func loginWithBiometrics() {
        getBiometrics { success in
            DispatchQueue.main.async {
                if success {
                    self.loginPasswordTextField = self.savedPassword
                    self.performLogin()
                } else {
                    Mixpanel.mainInstance().track(event: NSLocalizedString("Unable to access biometrics",
                                                                           comment: ""))
                }
            }
        }
    }
    
    /// Create an account
    func createAccount() {
        appController.setLoadingInProgress(withMessage: NSLocalizedString("Account creation in progress...",
                                                                          comment: ""))
        loginErrorMessage = ""
        
        guard createAccountEmailTextField.isNotEmpty
                && createAccountPasswordTextField.isNotEmpty
                && createAccountPasswordVerification.isNotEmpty else {
            createAccountErrorMessage = NSLocalizedString("An email and a password are required!",
                                                          comment: "")
            let group = DispatchGroup()
            appController.resetLoadingInProgress(group: group)
            return
        }
        
        guard createAccountEmailTextField.isEmail else {
            createAccountErrorMessage = NSLocalizedString("An valid email is required!",
                                                          comment: "")
            let group = DispatchGroup()
            appController.resetLoadingInProgress(group: group)
            return
        }
        
        userManager.createAccount(for: UserToCreate(email: createAccountEmailTextField.trimmingCharacters(in: .whitespacesAndNewlines),
                                                    password: createAccountPasswordTextField,
                                                    passwordVerification: createAccountPasswordVerification))
    }
    
    /// Disconnect the user
    func disconnect() {
        self.userManager.disconnectUser()
        DispatchQueue.main.async {
            self.loginPasswordTextField = ""
            self.isConnected = false
        }
    }
    
    /// Update connected user
    func updateUser() {
        appController.setLoadingInProgress(withMessage: NSLocalizedString("Updating in progress...",
                                                                          comment: ""))
        
        guard userToUpdate.password == userToUpdate.passwordVerification else {
            let group = DispatchGroup()
            appController.resetLoadingInProgress(group: group)
            
            group.notify(queue: .main) {
                self.appController.showAlertView(withMessage: NSLocalizedString("Both new password must match!",
                                                                           comment: ""),
                                            andTitle: NSLocalizedString("Password error!",
                                                                        comment: ""))
            }
            
            return
        }
        
        if userToUpdate.phoneNumber.isNotEmpty && !userToUpdate.phoneNumber.isPhone {
            let group = DispatchGroup()
            appController.resetLoadingInProgress(group: group)
            
            group.notify(queue: .main) {
                self.appController.showAlertView(withMessage: NSLocalizedString("You must enter a valid phone number!",
                                                                           comment: ""),
                                            andTitle: NSLocalizedString("Phone number error",
                                                                        comment: ""))
            }
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
                let group = DispatchGroup()
                self.appController.resetLoadingInProgress(group: group)
                
                group.notify(queue: .main) {
                    switch notificationName {
                    case Notification.AniTrip.loginSuccess.notificationName:
                        self.actionWhenLoginSuccess()
                    case Notification.AniTrip.accountCreationSuccess.notificationName:
                        Mixpanel.mainInstance().track(event: "New account creation")
                        self.createAccountEmailTextField = ""
                        self.createAccountPasswordTextField = ""
                        self.createAccountPasswordVerification = ""
                        self.appController.showAlertView(withMessage: notificationMessage,
                                                         andTitle: NSLocalizedString("Success!",
                                                                                     comment: ""))
                    case Notification.AniTrip.updateProfileSuccess.notificationName:
                        self.userToUpdate.password = ""
                        self.userToUpdate.passwordVerification = ""
                        self.successUpdate = true
                    case Notification.AniTrip.loginWrongCredentials.notificationName,
                        Notification.AniTrip.accountCreationPasswordError.notificationName,
                        Notification.AniTrip.accountCreationInformationsError.notificationName:
                        self.appController.showAlertView(withMessage: notificationMessage,
                                                         andTitle: NSLocalizedString("Error",
                                                                                     comment: ""))
                    case Notification.AniTrip.updatePictureSuccess.notificationName:
                        self.showUpdateProfileImage = false
                    default: break
                    }
                }
            }
        }
    }
    
    /// Getting biometric authentication to active it
    private func activateBiometric() {
        getBiometrics { success in
            DispatchQueue.main.async {
                if success {
                    self.savedEmail = self.loginEmailTextField
                    self.savedPassword = self.loginPasswordTextField
                    self.appController.showAlertView(withMessage: NSLocalizedString("Biometrics is now active!",
                                                                                    comment: ""),
                                                     andTitle: NSLocalizedString("Success",
                                                                                 comment: ""))
                } else {
                    Mixpanel.mainInstance().track(event: NSLocalizedString("Unable to access biometrics",
                                                                           comment: ""))
                }
            }
        }
    }
    
    /// Get biometrics
    private func getBiometrics(completionHandler: @escaping ((Bool) -> Void)) {
        var error: NSError?
        let laContext = LAContext()
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let biometrics = laContext.biometryType == .faceID ? "FaceId" : "TouchId"
            let needAccess = NSLocalizedString("Need access to", comment: "")
            let toAuthenticate = NSLocalizedString("to authenticate to the app.", comment: "")
            let reason = "\(needAccess) \(biometrics) \(toAuthenticate)"
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    completionHandler(success)
                }
            }
        }
        completionHandler(false)
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
