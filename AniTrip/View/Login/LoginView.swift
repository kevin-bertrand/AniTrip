//
//  LoginView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import LocalAuthentication
import SwiftUI

struct LoginView: View {
    @State private var selectedPage: Int = 0
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(minWidth: 75, maxWidth: 150, minHeight: 75, maxHeight: 150)
                .aspectRatio(1, contentMode: .fit)
            
            HStack {
                Spacer()
                LoginToolbar(selected: $selectedPage)
                Spacer()
            }
            
            if selectedPage == 1 {
                CreateAccountView()
                    .transition(.opacity)
            } else {
                LoginSubview()
                    .transition(.opacity)
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
