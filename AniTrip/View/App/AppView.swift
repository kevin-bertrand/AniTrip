//
//  AppView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 12/07/2022.
//

import DesynticLibrary
import SwiftUI

struct AppView: View {
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var volunteersController: VolunteersController
    
    @State private var showBiometricsActivation: Bool = false
    @State private var displayActivateAccount: Bool = false
    
    var body: some View {
        TabView {
            HomeView()
                .navigationTitle(Text("🏠 Home"))
                .asNavigationView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            TripsView()
                .navigationTitle(Text("📍 Trips"))
                .asNavigationView()
                .tabItem {
                    Label("Trips", systemImage: "map.fill")
                }
            
            VolunteersView()
                .navigationTitle(Text("👥 Volunteers"))
                .asNavigationView()
                .tabItem {
                    Label("Volunteers", systemImage: "person.3.fill")
                }
            
            SettingsView()
                .navigationTitle("⚙️ Settings")
                .asNavigationView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .alert(isPresented: $showBiometricsActivation) {
            Alert(title: Text("Would you like to use FaceId for further login?"),
                  primaryButton: .default(Text("Yes"), action: {
                userController.canUseBiometric = true
            }),
                  secondaryButton: .cancel(Text("No"), action: {
                userController.canUseBiometric = false
            }))
        }
        .sheet(isPresented: $displayActivateAccount) {
            ActivateAccountView()
        }
        .syncBool($showBiometricsActivation, with: $userController.loginShowBiometricAlert)
        .syncBool($displayActivateAccount, with: $volunteersController.displayActivateAccount)
        .checkAppVersion(mustUpdateMessage: "Your app is not up to date. Please, update it to get the latest features", mustUpdateTitle: "Update", mustUpdateButton: "Update", cancelButton: "Cancel")
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
