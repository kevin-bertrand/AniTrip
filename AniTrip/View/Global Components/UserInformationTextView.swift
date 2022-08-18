//
//  UserInformationTextView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/08/2022.
//

import SwiftUI

struct UserInformationTextView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(title): ")
                .bold()
            Text(value)
        }
    }
}

struct UserInformationTextView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationTextView(title: "Name", value: "Doe")
    }
}
