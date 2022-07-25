//
//  LoginView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import LocalAuthentication
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userController: UserController
    @State private var selectedPage: Int = 0
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
            
            HStack {
                LoginToolbar(selected: $selectedPage)
                Spacer()
            }
            
            if selectedPage == 1 {
                CreateAccountView()
            } else {
                LoginSubview()
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserController())
    }
}
