//
//  AppView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 12/07/2022.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            NavigationView {
                Text("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            NavigationView {
                Text("Trips")
            }
            .tabItem {
                Label("Trips", systemImage: "map.fill")
            }
            
            NavigationView {
                Text("Volunteers")
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
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
