//
//  LoginView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var userController: UserController
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
            
            Spacer()
            
            TextFieldWithIcon(text: $userController.loginEmailTextField, icon: "person.fill", placeholder: "example@mail.com", keyboardType: .emailAddress)
            TextFieldWithIcon(text: $userController.loginPasswordTextField, icon: "lock.fill", placeholder: "Password", isSecure: true)
            
            Text(userController.loginErrorMessage)
                .font(.title3)
                .bold()
                .foregroundColor(.red)
            
            Spacer()
            
            ButtonWithIcon(action: {
                userController.performLogin()
            }, icon: "chevron.right", title: "LOGIN")
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserController())
    }
}
