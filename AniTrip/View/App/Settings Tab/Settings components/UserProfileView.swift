//
//  UserProfileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import MessageUI
import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        Form {
            Section {
                UserCellView()
            }
            .listRowBackground(Color.clear)
            
            Section(header: Text("Address")) {
                AddressTileView(address: userController.connectedUser?.address)
            }
            
            Section(header: Text("Contact informations")) {
                HStack {
                    Text("Email")
                    Spacer()
                    
                    if let email = userController.connectedUser?.email,
                       let url = URL(string: "mailto:\(email)") {
                        Link(email, destination: url)
                            .foregroundColor(.accentColor)
                    }
                }
                
                HStack {
                    Text("Phone")
                    Spacer()
                    
                    if let phone = userController.connectedUser?.phoneNumber,
                       let url = URL(string: "tel:\(phone)") {
                        Link(phone, destination: url)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            Section(header: Text("Missions")) {
                Text(userController.connectedUser?.missions.joined(separator: ", ") ?? "")
            }
        }
        .toolbar {
            NavigationLink {
                UpdateProfileView()
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView()
                .environmentObject(UserController())
                .environmentObject(AppController())
        }
    }
}
