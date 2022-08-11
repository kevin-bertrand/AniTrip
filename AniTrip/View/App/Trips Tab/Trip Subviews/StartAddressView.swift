//
//  StartAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import SwiftUI

struct StartAddressView: View {
    @EnvironmentObject var tripController: TripController
    @Binding var step: Int
    @Binding var trip: UpdateTrip
    @State private var canValidateStep: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    tripController.showUpdateTripView = false
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
                }.disabled(!canValidateStep)
            }
            .padding()
            
            DetectAddressView(address: $trip.startingAddress, addressFound: $canValidateStep, name: "Starting address")
        }
    }
}

struct AddingStartAddressView_Previews: PreviewProvider {
    static var previews: some View {
        StartAddressView(step: .constant(1),
                         trip: .constant(UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress)))
            .environmentObject(TripController(appController: AppController()))
    }
}
