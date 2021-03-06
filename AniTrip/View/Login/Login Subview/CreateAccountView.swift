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
            Spacer()
            
            Group {
                TextFieldWithIcon(text: $userController.createAccountEmailTextField,  icon: "person.fill", placeholder: "example@mail.com", keyboardType: .emailAddress)
                
                TextFieldWithIcon(text: $userController.createAccountPasswordTextField,  icon: "lock", placeholder: "Password", isSecure: true)

                TextFieldWithIcon(text: $userController.createAccountPasswordVerificationTextField,  icon: "lock", placeholder: "Password verification", isSecure: true)
                
                Text(userController.createAccountErrorMessage)
                    .bold()
                    .foregroundColor(.red)
            }.padding(.vertical)
        
            Spacer()
            
            ButtonWithIcon(action: {
                userController.createAccount()
            }, icon: nil, title: "Ask new account")
        }
        .alert(isPresented: $userController.showSuccessAccountCreationAlert) {
            Alert(title: Text("Success"), message: Text(Notification.AniTrip.accountCreationSuccess.notificationMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(UserController())
    }
}
