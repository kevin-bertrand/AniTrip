//
//  PasswordFormTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct PasswordFormTileView: View {
    // MARK: State properties
    @State private var showPassword = false
    
    // MARK: Bingin properties
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Group {
                if showPassword {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .padding()
            .frame(height: 20)
            
            Button {
                showPassword.toggle()
            } label: {
                if showPassword {
                    Image(systemName: "eye.slash")
                } else {
                    Image(systemName: "eye")
                }
            }
            .padding()
            .frame(width: 20)
        }
    }
}

struct PasswordFormTileView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordFormTileView(text: .constant(""), placeholder: "")
    }
}
