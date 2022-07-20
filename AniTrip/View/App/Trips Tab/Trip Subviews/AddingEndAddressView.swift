//
//  AddingEndAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct AddingEndAddressView: View {
    @EnvironmentObject var tripController: TripController
    @Binding var step: Int
    
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
            }
            .padding()
            
            DetectAddressView(address: $tripController.newTrip.endingAddress, name: "Ending address")
        }
    }
}

struct AddingEndAddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddingEndAddressView(step: .constant(2))
            .environmentObject(TripController(appController: AppController()))
    }
}
