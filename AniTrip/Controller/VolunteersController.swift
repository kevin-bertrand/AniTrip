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
    
    var appController: AppController
    
    // MARK: Methods
    /// Getting volunteers list
    func getList(byUser user: User?) {
        volunteersManager.getList(byUser: user)
    }
    
    /// Activate account
    func activateAccount(of volunteer: Volunteer, by user: User?) {
        appController.setLoadingInProgress(withMessage: "Activation in progress...")
        
        guard let user = user, user.position == .admin else {
            appController.resetLoadingInProgress()
            appController.showAlertView(withMessage: "You are not authorized!")
            return
        }
        
        volunteersManager.activate(account: volunteer, byUser: user)
    }
    
    /// Desactivate account
    func desactivateAccount(of volunteer: Volunteer, by user: User?) {
        appController.setLoadingInProgress(withMessage: "Desactivation in progress...")
        
        guard let user = user, user.position == .admin else {
            appController.resetLoadingInProgress()
            appController.showAlertView(withMessage: "You are not authorized!")
            return
        }
        
        volunteersManager.desactivate(account: volunteer, byUser: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure volunteers notifications
        configureNotification(for: Notification.AniTrip.gettingVolunteersListSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.activationSuccess.notificationName)
        configureNotification(for: Notification.AniTrip.desactivationSuccess.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let volunteersManager: VolunteersManager = VolunteersManager()
    
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
            case Notification.AniTrip.gettingVolunteersListSuccess.notificationName:
                volunteersList = volunteersManager.volunteersList
            case Notification.AniTrip.activationSuccess.notificationName,
                Notification.AniTrip.desactivationSuccess.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage, mustReturnToPreviousView: true)
            default: break
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
