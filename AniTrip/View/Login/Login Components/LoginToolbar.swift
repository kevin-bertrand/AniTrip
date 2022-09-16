//
//  LoginToolbar.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 25/07/2022.
//

import SwiftUI

struct LoginToolbar: View {
    @Binding var selected: Int
    
    var body: some View {
        HStack {
            ToolbarTabItemView(selected: $selected, title: NSLocalizedString("LOGIN", comment: "Login tab"), tabId: 0)
            
            ToolbarTabItemView(selected: $selected, title: NSLocalizedString("REGISTER", comment: "Register tab"), tabId: 1)
        }
        .padding(8)
        .animation(.default)
    }
}

struct LoginToolbar_Previews: PreviewProvider {
    static var previews: some View {
        LoginToolbar(selected: .constant(1))
    }
}
