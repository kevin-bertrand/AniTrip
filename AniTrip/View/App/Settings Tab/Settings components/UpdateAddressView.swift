//
//  UpdateAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UpdateAddressView: View {
    @State private var showMapView: Bool = false
    @Binding var address: Address
    @State private var addressToModify: Address = LocationController.emptyAddress
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Button {
                    showMapView = true
                } label: {
                    Text("Select on map")
                }
                .padding(.vertical, 10)
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
        .onAppear {
            addressToModify = address
        }
        .sheet(isPresented: $showMapView, onDismiss: {
            if addressToModify != LocationController.emptyAddress {
                address = addressToModify
            }
        }, content: {
            SearchAddressView(address: $addressToModify, showMapSheet: $showMapView)
        })
    }
}

struct UpdateAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAddressView(address: .constant(LocationController.emptyAddress))
    }
}
