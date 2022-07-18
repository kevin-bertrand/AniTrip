//
//  UpdateProfileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UpdateProfileView: View {
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        Form {
            Section(header: Text("User Informations")) {
                EditUserInfoTileView(text: $userController.userToUpdate.firstname, title: "Firstname")
                EditUserInfoTileView(text: $userController.userToUpdate.lastname, title: "Lastname")
            }
            
            Group {
                Section(header: Text("Address")) {
                    UpdateAddressView(address: $userController.userToUpdate.address)
                }
                
                Section(header: Text("Contact")) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(userController.userToUpdate.email)
                            .foregroundColor(.gray)
                    }
                    
                    EditUserInfoTileView(text: $userController.userToUpdate.phoneNumber, keyboardType: .phonePad, title: "Phone")
                }
            }
            .autocorrectionDisabled(true)
            
            Section(header: Text("Association")) {
                if userController.connectedUser?.position == .admin {
                    Picker("Position", selection: $userController.userToUpdate.position) {
                        ForEach(Position.allCases, id: \.self) { position in
                            Text(position.name)
                                .tag(position)
                        }
                    }
                } else {
                    HStack {
                        Text("Position")
                        Spacer()
                        Text(userController.userToUpdate.position.name)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            MissionsUpdateTileView(missions: $userController.userToUpdate.missions)
            
            Section(header: Text("Security")) {
                PasswordFormTileView(text: $userController.userToUpdate.password, placeholder: "Password")
                PasswordFormTileView(text: $userController.userToUpdate.passwordVerification, placeholder: "Password verification")
            }
        }
        .toolbar {
            Button {
                userController.updateUser()
            } label: {
                Image(systemName: "v.circle")
            }
        }
    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
            .environmentObject(UserController())
    }
}
