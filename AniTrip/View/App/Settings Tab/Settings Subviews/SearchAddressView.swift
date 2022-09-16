//
//  SearchAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 21/07/2022.
//

import SwiftUI

struct SearchAddressView: View {
    @Binding var address: Address
    @Binding var showMapSheet: Bool
    @State private var canValidateAddress: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    address = LocationController.emptyAddress
                    showMapSheet = false
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button {
                    showMapSheet = false
                } label: {
                    Text("Validate")
                        .foregroundColor(.accentColor)
                }
                .disabled(!canValidateAddress)
            }.padding()
            
            DetectAddressView(address: $address,
                              addressFound: $canValidateAddress,
                              name: NSLocalizedString("Address", comment: ""))
        }
    }
}

struct SearchAddressView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAddressView(address: .constant(LocationController.emptyAddress), showMapSheet: .constant(true))
    }
}
