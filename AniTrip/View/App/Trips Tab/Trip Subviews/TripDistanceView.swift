//
//  TripDistanceView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct TripDistanceView: View {
    @EnvironmentObject private var tripController: TripController
    
    @Binding var step: Int
    @Binding var trip: UpdateTrip
    
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
                .disabled(Double(trip.totalDistance) ?? 0.0 <= 0.0 ? true : false)
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
                VStack {
                    HStack {
                        TextField("0.0", text: $trip.totalDistance)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        Text("km")
                    }
                    .frame(width: 150)
                    .font(.title)
                    
                    Toggle(isOn: $trip.isRoundTrip) {
                        Label("Is round trip?", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .frame(width: 300)
                    .font(.title2.bold())
                }
            }

            Spacer()
        }
    }
}

struct NewTripDistanceView_Previews: PreviewProvider {
    static var previews: some View {
        TripDistanceView(step: .constant(3),
                         trip: .constant(TripController.emptyUpdateTrip))
            .environmentObject(TripController(appController: AppController()))
    }
}
