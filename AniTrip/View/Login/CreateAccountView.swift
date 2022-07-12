//
//  CreateAccountView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 12/07/2022.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject private var userController: UserController
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.vertical)
            
            Text("Enter your email and a password. Then click on the button bellow. When the account will be validaded by the administrator, you will receive an email.")
                .font(.callout)
                .foregroundColor(.gray)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Group {
                TextFieldWithIcon(text: $userController.createAccountEmailTextField,  icon: "person.fill", placeholder: "example@mail.com", keyboardType: .emailAddress)
                
                TextFieldWithIcon(text: $userController.createAccountPasswordTextField,  icon: "lock", placeholder: "Password", isSecure: true)

                TextFieldWithIcon(text: $userController.createAccountPasswordVerificationTextField,  icon: "lock", placeholder: "Password verification", isSecure: true)
                
                Text(userController.createAccountErrorMessage)
                    .bold()
                    .foregroundColor(.red)
            }.padding()
            
            Spacer()
            
            ButtonWithIcon(action: {
                userController.createAccount()
            }, icon: nil, title: "Ask new account")
        }
        .padding()
        .alert(isPresented: $userController.showSuccessAccountCreationAlert) {
            Alert(title: Text("Success"), message: Text(Notification.AniTrip.accountCreationSuccess.notificationMessage), dismissButton: .default(Text("OK"), action: {
                userController.showCreateAcountView = false
            }))
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
