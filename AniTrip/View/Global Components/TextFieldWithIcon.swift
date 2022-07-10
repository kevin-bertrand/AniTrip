//
//  TextFieldWithIcon.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 10/07/2022.
//

import SwiftUI

struct TextFieldWithIcon: View {
    // MARK: State properties
    @State private var showPassword = false
    
    // MARK: Bingin properties
    @Binding var text: String
    
    // MARK: Local properties
    let icon: String?
    let placeholder: String
    
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    // MARK: Body
    var body: some View {
        HStack(spacing: 0) {
            if let icon = icon,
               let image = Image(systemName: icon) {
                image
                    .padding()
                    .foregroundColor(.accentColor)
            }
            
            Group {
                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .autocorrectionDisabled(keyboardType == .default ? false : true)
                            .autocapitalization(keyboardType == .default ? .sentences : .none)
                    }
                }.padding()
                    .keyboardType(keyboardType)

                if isSecure {
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
                }
            }
            .background(.white)
        }
        .background(Color("ButtonIconBackground"))
        .cornerRadius(25)
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .stroke(style: .init(lineWidth: 1))
        }
    }
}

struct TextFieldWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithIcon(text: .constant(""), icon: "", placeholder: "")
    }
}
