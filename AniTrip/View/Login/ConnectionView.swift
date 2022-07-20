//
//  ConnectionView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import SwiftUI

struct ConnectionView: View {
    @State private var authPath: Int? = nil
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 150, height: 150)
            
            Spacer()
            
            Picker(selection: Binding<Int>(
                get: { self.authPath ?? 0 },
                set: { tag in
                    withAnimation { // needed explicit for transitions
                        self.authPath = tag
                    }
                }),
                   label: Text("Authentication Path")) {
                Text("Log In").tag(0)
                Text("Sign Up").tag(1)
            }
                   .pickerStyle(SegmentedPickerStyle())
            
            ZStack {
                Rectangle().fill(Color.clear)
                if authPath == 0 || authPath == nil {
                    LoginView()
                        .transition(.move(edge: .leading))
                }
                
                if authPath == 1 {
                    CreateAccountView()
                        .transition(.move(edge: .trailing))
                }
            }
            
        }
        
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView()
    }
}
