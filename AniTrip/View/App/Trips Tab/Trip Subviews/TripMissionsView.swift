//
//  TripMissionsView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct TripMissionsView: View {
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
                
                Image(systemName: "5.circle")
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
            
            HStack {
                TextField("New mission", text: $tripController.newMission)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                Button {
                    tripController.addMission()
                } label: {
                    Label("Add", systemImage: "plus.circle")
                }
                .padding()
            }
            
            List {
                ForEach(trip.missions, id: \.self) { mission in
                    Text(mission)
                }
                .onDelete { index in
                    trip.missions.remove(atOffsets: index)
                }

            }
            
            Spacer()
        }
    }
}

struct NewTripMissionsView_Previews: PreviewProvider {
    static var previews: some View {
        TripMissionsView(step: .constant(5),
                         trip: .constant(TripController.emptyUpdateTrip))
            .environmentObject(TripController(appController: AppController()))
    }
}
