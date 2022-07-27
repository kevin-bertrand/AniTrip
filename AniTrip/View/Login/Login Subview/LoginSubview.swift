//
//  LoginSubview.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 25/07/2022.
//

import LocalAuthentication
import SwiftUI

struct LoginSubview: View {
    @EnvironmentObject private var userController: UserController
    let laContext = LAContext()
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                TextFieldWithIcon(text: $userController.loginEmailTextField, icon: "person.fill", placeholder: "example@mail.com", keyboardType: .emailAddress)
                
                HStack {
                    Spacer()
                    Button {
                        userController.loginSaveEmail.toggle()
                    } label: {
                        Text("Save email? ")
                        Image(systemName: userController.loginSaveEmail ? "checkmark.square" : "square")
                    }
                }
                .padding(.bottom, 25)
                
                TextFieldWithIcon(text: $userController.loginPasswordTextField, icon: "lock.fill", placeholder: "Password", isSecure: true)
                
                Text(userController.loginErrorMessage)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
            }
            
            if userController.displayActivateAccount {
                Text("Connect to activate the new account of \(userController.accountToActivateEmail)")
                    .font(.body.bold())
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            HStack {
                ButtonWithIcon(action: {
                    userController.checkSaveEmail()
                    userController.performLogin()
                }, icon: "chevron.right", title: "LOGIN")
                
                if userController.getBiometricStatus() {
                    Button {
                        userController.loginWithBiometrics()
                    } label: {
                        Image(systemName: (laContext.biometryType == .faceID) ? "faceid" : "touchid")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            userController.loginEmailTextField = userController.savedEmail
            
            if userController.savedEmail.isNotEmpty {
                userController.loginSaveEmail = true
            }
        }
    }
}

struct LoginSubview_Previews: PreviewProvider {
    static var previews: some View {
        LoginSubview()
            .environmentObject(UserController())
    }
}
