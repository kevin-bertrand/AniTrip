//
//  AddingStartAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import MapKit
import SwiftUI

struct AddingStartAddressView: View {
    @EnvironmentObject var tripController: TripController
    @Binding var step: Int
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    tripController.showAddNewTripView = false
                } label: {
                    Label("Cancel", systemImage: "x.circle")
                        .foregroundColor(.red)
                }
                Spacer()
                
                Image(systemName: "1.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                                
                Spacer()
                
                Button {
                    withAnimation {
                        step += 1
                    }
                } label: {
                    Text("Next")
                    Image(systemName: "arrow.right.circle")
                }
            }
            .padding()
            
            DetectAddressView(address: $tripController.newTrip.startingAddress, name: "Starting address")
        }
    }
}

struct AddingStartAddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddingStartAddressView(step: .constant(1))
            .environmentObject(TripController(appController: AppController()))
    }
}
