//
//  EditUserInfoTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct EditUserInfoTileView: View {
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Group {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .multilineTextAlignment(.trailing)
            .keyboardType(keyboardType)
        }
    }
}

struct EditUserInfoTileView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserInfoTileView(text: .constant(""), title: "")
    }
}
