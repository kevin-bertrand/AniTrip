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
    @EnvironmentObject private var volunteersController: VolunteersController
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    private let laContext = LAContext()
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                TextFieldWithIcon(text: $email,
                                  icon: "person.fill",
                                  placeholder: NSLocalizedString("example@mail.com",
                                                                 comment: "Example email"),
                                  keyboardType: .emailAddress)
                
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
                
                TextFieldWithIcon(text: $password,
                                  icon: "lock.fill",
                                  placeholder: NSLocalizedString("Password",
                                                                 comment: "Password placeholder"),
                                  isSecure: true)
                
                Text(userController.loginErrorMessage)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.red)
            }
            
            if volunteersController.displayActivateAccount {
                Text("Connect to activate the new account of \(volunteersController.accountToActivateEmail)")
                    .font(.body.bold())
                    .foregroundColor(.accentColor)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            HStack {
                ButtonWithIcon(isLoading: .constant(false), action: {
                    userController.checkSaveEmail()
                    userController.performLogin()
                }, icon: "chevron.right",
                               title: NSLocalizedString("LOGIN", comment: "Login button"))
                
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
        .syncText($email, with: $userController.loginEmailTextField)
        .syncText($password, with: $userController.loginPasswordTextField)
        .onAppear {
            email = userController.loginEmailTextField
        }
    }
}

struct LoginSubview_Previews: PreviewProvider {
    static var previews: some View {
        LoginSubview()
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
