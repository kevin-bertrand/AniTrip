//
//  VolunteersController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation
import UIKit

final class VolunteersController: ObservableObject {
    // MARK: Static
    static let emptyVolunteer = Volunteer(imagePath: nil,
                                          id: "",
                                          firstname: "",
                                          lastname: "",
                                          email: "",
                                          phoneNumber: "",
                                          gender: "",
                                          position: .admin,
                                          missions: [],
                                          address: LocationController.emptyAddress,
                                          isActive: true)
    
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
        DispatchQueue.main.async {
            self.volunteersManager.getList(byUser: user)
        }
    }
    
    /// Activate account
    func activateAccount(of volunteer: VolunteerToActivate, by user: User?) {
        guard let user = user, user.position == .admin else {
            appController.showAlertView(withMessage: NSLocalizedString("You are not authorized!",
                                                                       comment: ""),
                                        andTitle: NSLocalizedString("Error",
                                                                    comment: ""))
            return
        }
        
        volunteersManager.activate(account: volunteer, byUser: user)
    }
    
    /// Desactivate account
    func desactivateAccount(of volunteer: Volunteer, by user: User?) {
        guard let user = user, user.position == .admin else {
            appController.showAlertView(withMessage: NSLocalizedString("You are not authorized!",
                                                                       comment: ""),
                                        andTitle: NSLocalizedString("Error",
                                                                    comment: ""))
            return
        }
        
        volunteersManager.desactivate(account: volunteer, byUser: user)
    }
    
    /// Refuse the activation
    func refuseActivation() {
        accountToActivateEmail = ""
        activationMessage = NSLocalizedString("Account not activate", comment: "")
        activationTitle = NSLocalizedString("You refused the activation", comment: "")
        showActivationAlert = true
    }
    
    /// Reset the activation view
    func resetActivationView() {
        accountToActivateEmail = ""
        activationMessage = NSLocalizedString("Account not activate", comment: "")
        activationTitle = NSLocalizedString("You refused the activation", comment: "")
        displayActivateAccount = false
        showActivationAlert = false
    }
    
    /// Change volunteer position
    func changePosition(of volunteer: Volunteer, by user: User?) {
        volunteersManager.changePosition(of: VolunteerToUpdatePosition(email: volunteer.email,
                                                                       position: volunteer.position),
                                         by: user)
    }
    
    /// Download volunteer profile image
    func downloadProfileImage(of volunteer: Volunteer, completionHandler: @escaping ((UIImage?) -> Void)) {
        volunteersManager.downlaodProfilePicture(of: volunteer) { image in
            completionHandler(image)
        }
    }
    
    /// Disconnect user
    func disconnect() {
        DispatchQueue.main.async {
            self.volunteersManager.disconnect()
            self.volunteersList = []
        }
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
        
        // Configure update position notification
        configureNotification(for: Notification.AniTrip.positionUpdated.notificationName)
        configureNotification(for: Notification.AniTrip.positionNotUpdated.notificationName)
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
                let group = DispatchGroup()
                self.appController.resetLoadingInProgress(group: group)
                
                group.notify(queue: .main) {
                    switch notificationName {
                    case Notification.AniTrip.gettingVolunteersListSuccess.notificationName:
                        self.volunteersList = self.volunteersManager.volunteersList
                        self.downloadAsyncProfileView()
                    case Notification.AniTrip.activationSuccess.notificationName:
                        if self.displayActivateAccount {
                            self.accountToActivateEmail = ""
                            self.activationMessage = NSLocalizedString("Activation success", comment: "")
                            self.activationTitle = NSLocalizedString("You accept the activation!", comment: "")
                            self.showActivationAlert = true
                        } else {
                            self.changeActivationStatusTitle = NSLocalizedString("Activation success!", comment: "")
                            self.changeActivationStatusMessage = NSLocalizedString("The account is now active!", comment: "")
                            self.changeActivationStatusAlert = true
                        }
                    case Notification.AniTrip.desactivationSuccess.notificationName:
                        self.changeActivationStatusTitle = NSLocalizedString("Desctivation success!", comment: "")
                        self.changeActivationStatusMessage = NSLocalizedString("The account is no longer active!", comment: "")
                        self.changeActivationStatusAlert = true
                    case Notification.AniTrip.showActivateAccount.notificationName:
                        self.accountToActivateEmail = notificationMessage
                        self.displayActivateAccount = true
                    case Notification.AniTrip.positionUpdated.notificationName:
                        self.changeActivationStatusTitle = NSLocalizedString("Success!", comment: "")
                        self.changeActivationStatusMessage = notificationMessage
                        self.changeActivationStatusAlert = true
                    case Notification.AniTrip.positionNotUpdated.notificationName:
                        self.changeActivationStatusTitle = NSLocalizedString("Error!", comment: "")
                        self.changeActivationStatusMessage = notificationMessage
                        self.changeActivationStatusAlert = true
                    default: break
                    }
                }
            }
        }
    }
    
    /// Filter volunteers list
    private func filterList() {
        if self.searchFilter.isEmpty {
            self.volunteersList = self.volunteersManager.volunteersList
        } else {
            self.volunteersList = self.volunteersManager.volunteersList.filter {
                $0.firstname.localizedCaseInsensitiveContains(self.searchFilter) ||
                $0.lastname.localizedCaseInsensitiveContains(self.searchFilter) ||
                !($0.missions.filter {$0.localizedCaseInsensitiveContains(self.searchFilter)}).isEmpty ||
                $0.email.localizedCaseInsensitiveContains(self.searchFilter) ||
                ($0.address != nil && $0.address?.city.localizedCaseInsensitiveContains(self.searchFilter) == true)
            }
        }
    }
    
    /// Async download of volunteer profile image
    private func downloadAsyncProfileView() {
        DispatchQueue.main.async {
            for index in 0..<self.volunteersList.count {
                self.downloadProfileImage(of: self.volunteersList[index]) { image in
                    self.volunteersList[index].image = image
                }
            }
        }
    }
}
