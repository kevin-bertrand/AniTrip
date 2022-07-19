//
//  AniTripApp.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

@main
struct AniTripApp: App {
    @StateObject private var appController: AppController = AppController()
    @StateObject private var userController: UserController = UserController()
    @AppStorage("anitripUseDefaultScheme") var useDefaultScheme: Bool = true
    @AppStorage("anitripUseDarkScheme") var useDarkScheme: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some Scene {
        WindowGroup {
            Group {
                ZStack {
                    if userController.isConnected {
                        AppView()
                    } else {
                        LoginView()
                    }
                    
                    if appController.loadingInProgress {
                        LoadingInProgressView()
                    }
                }
            }
            .environmentObject(userController)
            .environmentObject(appController)
            .alert(isPresented: $appController.showAlertView) {
                Alert(title: Text("Loading ended"), message: Text(appController.alertViewMessage), dismissButton: .default(Text("OK"), action: {
                    if appController.mustReturnToPreviousView {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }))
            }
            .alert(isPresented: $userController.loginShowBiometricAlert) {
                Alert(title: Text("Would you like to use FaceId for further login?"),
                      primaryButton: .default(Text("Yes"), action: {
                    userController.useBiometricLater()
                }),
                      secondaryButton: .cancel(Text("No"), action: {
                    userController.dontUseBiometric()
                }))
            }
            .onAppear {
                userController.appController = appController
            }
            .preferredColorScheme(useDefaultScheme ? nil : (useDarkScheme ? .dark : .light))
        }
    }
}
