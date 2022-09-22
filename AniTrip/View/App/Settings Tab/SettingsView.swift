//
//  SettingsView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import CoreLocation
import LocalAuthentication
import os
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appController: AppController
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var tripController: TripController
    @EnvironmentObject private var volunteersController: VolunteersController
    
    @AppStorage("anitripUseDefaultScheme") var useDefaultScheme: Bool = true
    @AppStorage("anitripUseDarkScheme") var useDarkScheme: Bool = false
    
    @State private var allowNotifications: Bool = false
    @State private var showAlert: Bool = false
    @State private var allowCurrentLocation: Bool = false
    
    private let laContext = LAContext()
    private let locationManager = CLLocationManager()
    
    var body: some View {
        Form {
            Section {
                ZStack {
                    UserCellView()
                    
                    NavigationLink {
                        UserProfileView()
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowBackground(Color.clear)
            }
            
            Section {
                NavigationLink {
                    TripsExportFilterView(userToExportId: userController.connectedUser?.id)
                } label: {
                    Label("Export trips", systemImage: "square.and.arrow.up.fill")
                }
            } header: {
                Text("Trips")
            }

            Section(header: Text("App Settings")) {
                Toggle("Use default iPhone scheme", isOn: $useDefaultScheme)
                
                if !useDefaultScheme {
                    Toggle("Use dark mode", isOn: $useDarkScheme)
                }
                
                if userController.appController.isBiometricAvailable {
                    Toggle("Use \(laContext.biometryType == .faceID ? "Face ID" : "Touch ID" )",
                           isOn: $userController.canUseBiometric)
                }
                
                Toggle("Allow notifications", isOn: $allowNotifications)
                    .disabled(true)
                    .onTapGesture {
                        showAlert.toggle()
                    }
                
                Toggle("Allow get current location", isOn: $allowCurrentLocation)
                    .disabled(true)
                    .onTapGesture {
                        showAlert.toggle()
                    }
            }
            
            Section {
                Button {
                    tripController.disconnect()
                    volunteersController.disconnect()
                    userController.disconnect()
                    appController.disconnect()
                } label: {
                    HStack {
                        Spacer()
                        Text("Disconnect")
                            .bold()
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .ephemeral, .provisional:
                    self.allowNotifications = true
                default:
                    self.allowNotifications = false
                }
            }
            
            switch locationManager.authorizationStatus {
            case .authorized, .authorizedAlways, .authorizedWhenInUse:
                allowCurrentLocation = true
            default:
                allowCurrentLocation = false
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Settings"),
                  message: Text("Go to the iPhone settings' to change notifications and location authorization!"),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .default(Text("Go to settings"),
                                            action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppController())
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
            .environmentObject(TripController(appController: AppController()))
    }
}
