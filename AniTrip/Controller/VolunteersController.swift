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
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure volunteers notifications
        configureNotification(for: Notification.AniTrip.gettingVolunteersListSuccess.notificationName)
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
        if let notificationName = notification.userInfo?["name"] as? Notification.Name {
            appController.resetLoadingInProgress()
            objectWillChange.send()
            
            switch notificationName {
            case Notification.AniTrip.gettingVolunteersListSuccess.notificationName:
                volunteersList = volunteersManager.volunteersList
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
