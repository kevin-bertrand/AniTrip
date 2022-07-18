//
//  DetailedTripView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct DetailedTripView: View {
    @EnvironmentObject var tripController: TripController
    
    let trip: Trip
    
    var body: some View {
        Form {
            Section(header: Text("Addresses")) {
                AddressTileView(address: trip.startingAddress, title: "Starting address")
                AddressTileView(address: trip.endingAddress, title: "Ending address")
            }
            
            Section(header: Text("Trip informations")) {
                HStack {
                    Text("Date")
                    Spacer()
                    Text("\(trip.date.toDate?.formatted(date: .numeric, time: .omitted) ?? "" )")
                }
                
                HStack {
                    Text("Total distance")
                    Spacer()
                    Text("\(trip.totalDistance.twoDigitPrecision) km")
                }
            }
            
            Section(header: Text("Missions")) {
                Text(trip.missions.joined(separator: ", "))
            }
            
            if let comment = trip.comment {
                Section(header: Text("Comments")) {
                    Text(comment)
                }
            }
        }
        .navigationTitle(Text("\(trip.startingAddress.city) → \(trip.endingAddress.city)"))
    }
}

struct DetailedTripView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTripView(trip: Trip(id: UUID(), date: "", missions: [], comment: nil, totalDistance: 0.0, startingAddress: MapController.emptyAddress, endingAddress: MapController.emptyAddress))
            .environmentObject(TripController(appController: AppController()))
    }
}
