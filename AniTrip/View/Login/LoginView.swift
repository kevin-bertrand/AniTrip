//
//  LoginView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
            
            Spacer()
            
            TextFieldWithIcon(text: $email, icon: "person.fill", placeholder: "example@mail.com", keyboardType: .emailAddress)
            TextFieldWithIcon(text: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)
            
            Spacer()
            
            ButtonWithIcon(action: {
                
            }, icon: "chevron.right", title: "LOGIN")
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
