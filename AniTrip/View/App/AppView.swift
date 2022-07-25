//
//  AppView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 12/07/2022.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var volunteersController: VolunteersController
    
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
            .sheet(isPresented: $userController.displayActivateAccount) {
                ActivateAccountView()
            }
            .alert(isPresented: $volunteersController.activationSuccessAlert) {
                Alert(title: Text("Account activate"), message: Text("You preceed to the activation"), dismissButton: .default(Text("OK"), action: {
                    userController.accountToActivateEmail = ""
                }))
            }
            .alert(isPresented: $volunteersController.activationRefused) {
                Alert(title: Text("Activation refused"), message: Text("You refused the activate"), dismissButton: .default(Text("OK"), action: {
                    userController.accountToActivateEmail = ""
                }))
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(UserController())
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
