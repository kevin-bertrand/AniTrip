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
    func showAlertView(withMessage message: String) {
        objectWillChange.send()
        resetLoadingInProgress()
        alertViewMessage = message
        showAlertView = true
    }
    
    /// Reset alert view
    func resetAlertView() {
        objectWillChange.send()
        alertViewMessage = ""
        showAlertView = false
    }
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
    
}
