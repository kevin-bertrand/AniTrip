//
//  AppView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 12/07/2022.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var volunteersController: VolunteersController

    @State private var showBiometricsActivation: Bool = false
    @State private var displayActivateAccount: Bool = false
    
    var body: some View {
        TabView {
            Group {
                NavigationView {
                    HomeView()
                        .navigationTitle(Text("🏠 Home"))
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                NavigationView {
                    TripsView()
                        .navigationTitle(Text("📍 Trips"))
                }
                .tabItem {
                    Label("Trips", systemImage: "map.fill")
                }
                
                NavigationView {
                    VolunteersView()
                        .navigationTitle(Text("👥 Volunteers"))
                }
                .tabItem {
                    Label("Volunteers", systemImage: "person.3.fill")
                }
                
                NavigationView {
                    SettingsView()
                        .navigationTitle("⚙️ Settings")
                }
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
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
