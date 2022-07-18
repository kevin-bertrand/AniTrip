//
//  SettingsView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userController: UserController
    @AppStorage("anitripUseDefaultScheme") var useDefaultScheme: Bool = true
    @AppStorage("anitripUseDarkScheme") var useDarkScheme: Bool = false
    
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
            
            Section(header: Text("App Settings")) {
                Toggle("Use default iPhone scheme", isOn: $useDefaultScheme)
                
                if !useDefaultScheme {
                    Toggle("Use dark mode", isOn: $useDarkScheme)
                }
            }
            
            Section {
                Button {
                    userController.disconnectUser()
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserController())
    }
}
