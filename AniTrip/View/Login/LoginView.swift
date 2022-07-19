//
//  LoginView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import LocalAuthentication
import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userController: UserController
    let laContext = LAContext()
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
            
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
            
            Spacer()
            
            withAnimation {
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
                        .frame(width: 50, height: 50)
                    }
                }
            }
            
            HStack {
                Text("No account ?")
                    .foregroundColor(.gray)
                
                Button {
                    userController.showCreateAcountView = true
                } label: {
                    Text("Ask one")
                }
            }
            .padding(.vertical)
        }
        .padding()
        .onAppear {
            userController.loginEmailTextField = userController.savedEmail
            
            if userController.savedEmail.isNotEmpty {
                userController.loginSaveEmail = true
            }
        }
        .sheet(isPresented: $userController.showCreateAcountView) {
            CreateAccountView()
        }
        .animation(.easeInOut, value: 1)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserController())
    }
}
