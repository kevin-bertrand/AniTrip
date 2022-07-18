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
            .alert(Text(appController.alertViewMessage), isPresented: $appController.showAlertView, actions: {
                Button {
                    appController.resetAlertView()
                } label: {
                    Text("Ok")
                }
            })
            .onAppear {
                userController.appController = appController
            }
            .preferredColorScheme(useDefaultScheme ? nil : (useDarkScheme ? .dark : .light))
        }
    }
}
