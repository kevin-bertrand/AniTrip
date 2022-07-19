//
//  AddTripView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct AddTripView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        Form {
            Section(header: Text("Addresses")) {
                UpdateAddressView(address: $tripController.newTrip.startingAddress, title: "Starting address")
                UpdateAddressView(address: $tripController.newTrip.endingAddress, title: "Ending address")
            }
            
            Section(header: Text("Trip informations")) {
                DatePicker("Date", selection: $tripController.newTrip.date, displayedComponents: .date)
                Toggle("Automatic distance calculation", isOn: $tripController.distanceAutoCalculation)
                HStack {
                    Text("Total distance")
                    Spacer()
                    TextField("0.0", text: $tripController.newTrip.totalDistance)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("km")
                }
            }
            
            MissionsUpdateTileView(missions: $tripController.newTrip.missions)
            
            Section(header: Text("Comments")) {
                TextEditor(text: $tripController.newTrip.comment)
            }
        }
        .onAppear {
            tripController.newTrip = NewTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: MapController.emptyAddress, endingAddress: MapController.emptyAddress)
        }
        .toolbar {
            Button {
                tripController.add(byUser: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController())
    }
}
