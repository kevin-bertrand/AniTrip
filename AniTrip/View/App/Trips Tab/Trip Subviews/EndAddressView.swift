//
//  EndAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct EndAddressView: View {
    @EnvironmentObject var tripController: TripController
    @Binding var step: Int
    @Binding var trip: UpdateTrip
    @State private var canValidateStep: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        step -= 1
                    }
                } label: {
                    Label("Previous", systemImage: "arrow.left.circle")
                        .foregroundColor(.red)
                }
                Spacer()
                
                Image(systemName: "2.circle")
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
                .disabled(!canValidateStep)
            }
            .padding()
            
            DetectAddressView(address: $trip.endingAddress, addressFound: $canValidateStep, name: "Ending address")
        }
    }
}

struct AddingEndAddressView_Previews: PreviewProvider {
    static var previews: some View {
        EndAddressView(step: .constant(2),
                       trip: .constant(UpdateTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress)))
            .environmentObject(TripController(appController: AppController()))
    }
}
