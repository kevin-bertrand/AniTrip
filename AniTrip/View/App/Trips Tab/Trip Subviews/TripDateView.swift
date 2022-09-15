//
//  TripDateView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct TripDateView: View {
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
                
                Image(systemName: "4.circle")
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
            
            Spacer()
            
            Text("Which day was the trip?")
                .multilineTextAlignment(.center)
                .font(.largeTitle.bold())
            DatePicker("", selection: $trip.date, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding()
            Spacer()
        }
    }
}

struct NewTripDateView_Previews: PreviewProvider {
    static var previews: some View {
        TripDateView(step: .constant(4),
                     trip: .constant(TripController.emptyUpdateTrip))
            .environmentObject(TripController(appController: AppController()))
    }
}
