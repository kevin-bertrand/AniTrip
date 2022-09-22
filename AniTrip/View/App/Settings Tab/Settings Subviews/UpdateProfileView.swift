//
//  UpdateProfileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UpdateProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var userController: UserController
    
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var address: Address = LocationController.emptyAddress
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var passwordVerification: String = ""
    @State private var showSuccessAlert: Bool = false
    @State private var missions: [String] = []
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        ProfilePictureView(image: .constant(userController.connectedUser?.image))
                        
                        Button {
                            userController.showUpdateProfileImage = true
                        } label: {
                            Text("Update image")
                        }
                        .padding(.top)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
            
            Section(header: Text("User Informations")) {
                EditUserInfoTileView(text: $firstname, title: "Firstname")
                EditUserInfoTileView(text: $lastname, title: "Lastname")
            }
            
            Group {
                Section(header: Text("Address")) {
                    UpdateAddressView(address: $address)
                }
                
                Section(header: Text("Contact")) {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(userController.userToUpdate.email)
                            .foregroundColor(.gray)
                    }
                    
                    EditUserInfoTileView(text: $phoneNumber,
                                         keyboardType: .phonePad,
                                         title: "Phone")
                }
            }
            .autocorrectionDisabled(true)
            
            Section(header: Text("Association")) {
                HStack {
                    Text("Position")
                    Spacer()
                    Text(userController.userToUpdate.position.name)
                        .foregroundColor(.gray)
                }
            }
            
            MissionsUpdateTileView(missions: $missions)
            
            Section(header: Text("Security")) {
                PasswordFormTileView(text: $password,
                                     placeholder: "Password")
                PasswordFormTileView(text: $passwordVerification,
                                     placeholder: "Password verification")
            }
        }
        .toolbar {
            Button {
                userController.updateUser()
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Success"),
                  message: Text(Notification.AniTrip.updateProfileSuccess.notificationMessage),
                  dismissButton: .default(Text("OK"),
                                          action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        .sheet(isPresented: $userController.showUpdateProfileImage) {
            UpdateProfileImageView()
        }
        .syncText($firstname, with: $userController.userToUpdate.firstname)
        .syncText($lastname, with: $userController.userToUpdate.lastname)
        .syncText($phoneNumber, with: $userController.userToUpdate.phoneNumber)
        .syncAddress($address, with: $userController.userToUpdate.address)
        .syncText($password, with: $userController.userToUpdate.password)
        .syncText($passwordVerification, with: $userController.userToUpdate.passwordVerification)
        .syncBool($showSuccessAlert, with: $userController.successUpdate)
        .syncTextArray($missions, with: $userController.userToUpdate.missions)
    }
}

struct UpdateProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfileView()
            .environmentObject(UserController(appController: AppController()))
    }
}
