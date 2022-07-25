//
//  AniTripApp.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

@main
struct AniTripApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @StateObject private var appController: AppController
    @StateObject private var userController: UserController
    @StateObject private var volunteerController: VolunteersController
    @StateObject private var tripController: TripController
    @AppStorage("anitripUseDefaultScheme") var useDefaultScheme: Bool = true
    @AppStorage("anitripUseDarkScheme") var useDarkScheme: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        let appController = AppController()
        _appController = StateObject(wrappedValue: appController)
        _userController = StateObject(wrappedValue: UserController())
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
                    .disabled(appController.loadingInProgress ? true : false)
                    
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
                Alert(title: Text("Loading ended"), message: Text(appController.alertViewMessage), dismissButton: .default(Text("OK"), action: {
                    if appController.mustReturnToPreviousView {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }))
            }
            .alert(isPresented: $userController.successBiometricActivationAlert) {
                Alert(title: Text("FaceId is activate!"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $userController.loginShowBiometricAlert) {
                Alert(title: Text("Would you like to use FaceId for further login?"),
                      primaryButton: .default(Text("Yes"), action: {
                    userController.canUseBiometric = true
                }),
                      secondaryButton: .cancel(Text("No"), action: {
                    userController.canUseBiometric = false
                }))
            }
            .onAppear {
                userController.appController = appController
            }
            .preferredColorScheme(useDefaultScheme ? nil : (useDarkScheme ? .dark : .light))
        }
    }
}
