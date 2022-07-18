//
//  TextFieldUnderlinedView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct TextFieldUnderlinedView: View {
    @Binding var text: String
    let title: String
    
    var body: some View {
        VStack {
            TextField(title, text: $text)
            Divider()
        }
        .padding(.horizontal, 5)
    }
}

struct TextFieldUnderlinedView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldUnderlinedView(text: .constant(""), title: "")
    }
}
