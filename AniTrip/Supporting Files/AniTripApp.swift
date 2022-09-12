//
//  AniTripApp.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI
import os

@main
struct AniTripApp: App {
    // Setting App Delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Declaration of state objects
    @StateObject private var appController: AppController
    @StateObject private var userController: UserController
    @StateObject private var volunteerController: VolunteersController
    @StateObject private var tripController: TripController
    
    // Getting color scheme settings store in memory
    @AppStorage("anitripUseDefaultScheme") var useDefaultScheme: Bool = true
    @AppStorage("anitripUseDarkScheme") var useDarkScheme: Bool = false
    
    // Getting the presentation mode environment variable
    @Environment(\.presentationMode) var presentationMode
    
    // Initialization
    init() {
        let appController = AppController()
        _appController = StateObject(wrappedValue: appController)
        _userController = StateObject(wrappedValue: UserController(appController: appController))
        _volunteerController = StateObject(wrappedValue: VolunteersController(appController: appController))
        _tripController = StateObject(wrappedValue: TripController(appController: appController))
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                ZStack {
                    Group {
                        if userController.isConnected {
                            AppView()
                        } else {
                            LoginView()
                        }
                    }
                    .disabled(appController.loadingInProgress)
                    
                    if appController.loadingInProgress {
                        LoadingInProgressView()
                    }
                }
            }
            .environmentObject(userController)
            .environmentObject(appController)
            .environmentObject(volunteerController)
            .environmentObject(tripController)
            .alert(isPresented: $appController.showAlertView) {
                Alert(title: Text(appController.alertViewTitle), message: Text(appController.alertViewMessage), dismissButton: .default(Text("OK")))
            }
            .preferredColorScheme(useDefaultScheme ? nil : (useDarkScheme ? .dark : .light))
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {_,_ in}
            }
        }
    }
}
