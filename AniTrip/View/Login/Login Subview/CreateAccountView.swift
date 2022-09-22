//
//  CreateAccountView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 12/07/2022.
//

import SwiftUI

struct CreateAccountView: View {
    @EnvironmentObject private var userController: UserController
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordVerification: String = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer()
            
            Group {
                TextFieldWithIcon(text: $email,
                                  icon: "person.fill",
                                  placeholder: NSLocalizedString("example@mail.com",
                                                                 comment: "Example email"),
                                  keyboardType: .emailAddress)
                
                TextFieldWithIcon(text: $password,
                                  icon: "lock",
                                  placeholder: NSLocalizedString("Password",
                                                                 comment: "Password placeholder"),
                                  isSecure: true)

                TextFieldWithIcon(text: $passwordVerification,
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
        .syncText($email, with: $userController.createAccountEmailTextField)
        .syncText($password, with: $userController.createAccountPasswordTextField)
        .syncText($passwordVerification, with: $userController.createAccountPasswordVerification)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
            .environmentObject(UserController(appController: AppController()))
    }
}
