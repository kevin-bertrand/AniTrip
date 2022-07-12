//
//  LoginView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userController: UserController
    @State private var saveEmail: Bool = false
    @AppStorage("anitripSavedEmail") private var savedEmail: String = ""
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
            
            Spacer()
            
            TextFieldWithIcon(text: $userController.loginEmailTextField, icon: "person.fill", placeholder: "example@mail.com", keyboardType: .emailAddress)
            
            HStack {
                Spacer()
                Button {
                    saveEmail.toggle()
                } label: {
                    Text("Save email? ")
                    Image(systemName: saveEmail ? "checkmark.square" : "square")
                }
            }
            .padding(.bottom, 25)
            
            TextFieldWithIcon(text: $userController.loginPasswordTextField, icon: "lock.fill", placeholder: "Password", isSecure: true)
            
            Text(userController.loginErrorMessage)
                .font(.title3)
                .bold()
                .foregroundColor(.red)
            
            Spacer()
            
            ButtonWithIcon(action: {
                checkSaveEmail()
                userController.performLogin()
            }, icon: "chevron.right", title: "LOGIN")
            
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
            userController.loginEmailTextField = savedEmail
            
            if savedEmail.isNotEmpty {
                saveEmail = true
            }
        }
        .sheet(isPresented: $userController.showCreateAcountView) {
            CreateAccountView()
        }
    }
    
    private func checkSaveEmail() {
        if saveEmail {
            savedEmail = userController.loginEmailTextField
        } else {
            savedEmail = ""
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserController())
    }
}
