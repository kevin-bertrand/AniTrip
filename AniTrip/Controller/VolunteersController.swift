//
//  VolunteersController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

final class VolunteersController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    @Published var volunteersList: [Volunteer] = []
    @Published var searchFilter: String = "" {
        didSet {
            filterList()
        }
    }
    
    // Volunteer profile view
    @Published var changeActivationStatusAlert: Bool = false
    var changeActivationStatusTitle: String = ""
    var changeActivationStatusMessage: String = ""
    
    // Activate account view
    @Published var displayActivateAccount: Bool = false
    @Published var accountToActivateEmail: String = ""
    @Published var showActivationAlert: Bool = false
    var activationMessage = ""
    var activationTitle = ""
    
    // MARK: Methods
    /// Getting volunteers list
    func getList(byUser user: User?) {
        volunteersManager.getList(byUser: user)
    }
    
    /// Activate account
    func activateAccount(of volunteer: VolunteerToActivate, by user: User?) {
        appController.setLoadingInProgress(withMessage: "Activation in progress...")
        
        guard let user = user, user.position == .admin else {
            appController.resetLoadingInProgress()
            appController.showAlertView(withMessage: "You are not authorized!", andTitle: "Error")
            return
        }
        
        volunteersManager.activate(account: volunteer, byUser: user)
    }
    
    /// Desactivate account
    func desactivateAccount(of volunteer: Volunteer, by user: User?) {
        appController.setLoadingInProgress(withMessage: "Desactivation in progress...")
        
        guard let user = user, user.position == .admin else {
            appController.resetLoadingInProgress()
            appController.showAlertView(withMessage: "You are not authorized!", andTitle: "Error")
            return
        }
        
        volunteersManager.desactivate(account: volunteer, byUser: user)
    }
    
    /// Refuse the activation
    func refuseActivation() {
        accountToActivateEmail = ""
        activationMessage = "Account not activate"
        activationTitle = "You refused the activation"
        showActivationAlert = true
    }
    
    /// Reset the activation view
    func resetActivationView() {
        accountToActivateEmail = ""
        activationMessage = "Account not activate"
        activationTitle = "You refused the activation"
        displayActivateAccount = false
        showActivationAlert = false
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure volunteers notifications
        configureNotification(for: Notification.AniTrip.gettingVolunteersListSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.activationSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.desactivationSuccess.notificationName)
        
        // Configure activate account notification
        configureNotification(for: Notification.AniTrip.showActivateAccount.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let volunteersManager: VolunteersManager = VolunteersManager()
    private var appController: AppController
    
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
                self.objectWillChange.send()
                
                switch notificationName {
                case Notification.AniTrip.gettingVolunteersListSuccess.notificationName:
                    self.volunteersList = self.volunteersManager.volunteersList
                case Notification.AniTrip.activationSuccess.notificationName:
                    if self.displayActivateAccount {
                        self.accountToActivateEmail = ""
                        self.activationMessage = "Activation success"
                        self.activationTitle = "You accept the activation!"
                        self.showActivationAlert = true
                    } else {
                        self.changeActivationStatusTitle = "Activation success!"
                        self.changeActivationStatusMessage = "The account is now active!"
                        self.changeActivationStatusAlert = true
                    }
                case Notification.AniTrip.desactivationSuccess.notificationName:
                    self.changeActivationStatusTitle = "Desctivation success!"
                    self.changeActivationStatusMessage = "The account is no longer active!"
                    self.changeActivationStatusAlert = true
                case Notification.AniTrip.showActivateAccount.notificationName:
                    self.accountToActivateEmail = notificationMessage
                    self.displayActivateAccount = true
                default: break
                }
            }
        }
    }
    
    /// Filter volunteers list
    private func filterList() {
        if searchFilter.isEmpty {
            volunteersList = volunteersManager.volunteersList
        } else {
            volunteersList = volunteersManager.volunteersList.filter { $0.firstname.localizedCaseInsensitiveContains(searchFilter) || $0.lastname.localizedCaseInsensitiveContains(searchFilter) || !($0.missions.filter {$0.localizedCaseInsensitiveContains(searchFilter)}).isEmpty }
        }
    }
}
