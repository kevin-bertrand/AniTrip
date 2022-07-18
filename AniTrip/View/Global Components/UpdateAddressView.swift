//
//  UpdateAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UpdateAddressView: View {
    @Binding var address: Address
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    TextFieldUnderlinedView(text: $address.streetNumber, title: "Number")
                    TextFieldUnderlinedView(text: $address.roadType, title: "Type")
                }
                TextFieldUnderlinedView(text: $address.roadName, title: "Street name")
                TextFieldUnderlinedView(text: $address.complement, title: "Complement")
                HStack {
                    TextFieldUnderlinedView(text: $address.zipCode, title: "Zip code")
                        .frame(width: 100)
                    TextFieldUnderlinedView(text: $address.city, title: "City")
                }
                TextFieldUnderlinedView(text: $address.country, title: "Country")
            }
        }
    }
}

struct UpdateAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAddressView(address: .constant(MapController.emptyAddress))
    }
}
