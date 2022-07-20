//
//  UpdateAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UpdateAddressView: View {
    @StateObject private var mapController: MapController = MapController()
    @State private var showMapSheet: Bool = false
    @Binding var address: Address
    var title: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let title = title {
                    Text(title)
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
//                Button {
//                    showMapSheet = true
//                } label: {
//                    Text("Select on map")
//                }
            }
            Group {
                HStack {
                    TextFieldUnderlinedView(text: $address.streetNumber, title: "Number")
                        .frame(width: 75)
                    TextFieldUnderlinedView(text: $address.roadName, title: "Street name")
                }
                
                TextFieldUnderlinedView(text: $address.complement, title: "Complement")
                HStack {
                    TextFieldUnderlinedView(text: $address.zipCode, title: "Zip code")
                        .frame(width: 100)
                    TextFieldUnderlinedView(text: $address.city, title: "City")
                }
                TextFieldUnderlinedView(text: $address.country, title: "Country")
            }
            .autocorrectionDisabled(true)
        }
//        .sheet(isPresented: $showMapSheet, content: {
//            DetectAddressView(address: $address, showSheet: $showMapSheet)
//        })
    }
}

struct UpdateAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAddressView(address: .constant(MapController.emptyAddress))
    }
}
