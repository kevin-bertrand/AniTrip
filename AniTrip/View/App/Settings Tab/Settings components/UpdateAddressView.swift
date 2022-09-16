//
//  UpdateAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UpdateAddressView: View {
    @Binding var address: Address
    @State private var showMapView: Bool = false
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
                    TextFieldUnderlinedView(text: $address.streetNumber,
                                            title: NSLocalizedString("Number",
                                                                     comment: ""))
                        .frame(width: 75)
                    TextFieldUnderlinedView(text: $address.roadName,
                                            title: NSLocalizedString("Street name",
                                                                     comment: ""))
                }
                
                TextFieldUnderlinedView(text: $address.complement,
                                        title: NSLocalizedString("Complement",
                                                                 comment: ""))
                HStack {
                    TextFieldUnderlinedView(text: $address.zipCode,
                                            title: NSLocalizedString("Zip code",
                                                                     comment: ""))
                        .frame(width: 100)
                    TextFieldUnderlinedView(text: $address.city,
                                            title: NSLocalizedString("City",
                                                                     comment: ""))
                }
                TextFieldUnderlinedView(text: $address.country,
                                        title: NSLocalizedString("Country",
                                                                 comment: ""))
            }
            .autocorrectionDisabled(true)
        }
        .onAppear {
            addressToModify = address
        }
        .sheet(isPresented: $showMapView, content: {
            SearchAddressView(address: $addressToModify,
                              showMapSheet: $showMapView)
        })
        .onChange(of: addressToModify) { newValue in
            address = newValue
        }
    }
}

struct UpdateAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateAddressView(address: .constant(LocationController.emptyAddress))
    }
}
