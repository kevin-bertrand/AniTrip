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
        ScrollView(showsIndicators: false) {
            Spacer()
            
            Group {
                TextFieldWithIcon(text: $userController.createAccountEmailTextField,
                                  icon: "person.fill",
                                  placeholder: NSLocalizedString("example@mail.com",
                                                                 comment: "Example email"),
                                  keyboardType: .emailAddress)
                
                TextFieldWithIcon(text: $userController.createAccountPasswordTextField,
                                  icon: "lock",
                                  placeholder: NSLocalizedString("Password",
                                                                 comment: "Password placeholder"),
                                  isSecure: true)

                TextFieldWithIcon(text: $userController.createAccountPasswordVerification,
                                  icon: "lock",
                                  placeholder: NSLocalizedString("Password verification",
                                                                 comment: "Password verification placeholder"),
                                  isSecure: true)
                
                Text(userController.createAccountErrorMessage)
                    .bold()
                    .foregroundColor(.red)
            }.padding(.vertical)
        
            Spacer(minLength: 10)
            
            ButtonWithIcon(isLoading: .constant(false), action: {
                userController.createAccount()
            }, icon: nil, title: NSLocalizedString("Ask new account", comment: ""))
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(UserController(appController: AppController()))
    }
}
