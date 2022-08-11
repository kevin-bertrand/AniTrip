//
//  NewTripDistanceView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct NewTripDistanceView: View {
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
                
                Image(systemName: "3.circle")
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
                .disabled(Double(tripController.newTrip.totalDistance) ?? 0.0 <= 0.0 ? true : false)
            }
            .padding()
            
            Spacer()
            
            Text("Trip distance:")
                .font(.largeTitle.bold())
            
            if tripController.loadingDistance {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding()
                    Text("Calculating trip distance")
                        .font(.title3)
                }
            } else {
                HStack {
                    TextField("0.0", text: $tripController.newTrip.totalDistance)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("km")
                }
                .frame(width: 150)
                .font(.title)
            }

            Spacer()
        }
    }
}

struct NewTripDistanceView_Previews: PreviewProvider {
    static var previews: some View {
        NewTripDistanceView(step: .constant(3))
            .environmentObject(TripController(appController: AppController()))
    }
}
