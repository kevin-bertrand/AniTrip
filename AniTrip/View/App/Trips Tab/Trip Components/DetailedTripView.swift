//
//  DetailedTripView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import MapKit
import SwiftUI
import UIKit

struct DetailedTripView: View {
    @EnvironmentObject private var tripController: TripController
    
    @Binding var trip: Trip
    
    @State private var updateTrip: UpdateTrip = TripController.emptyUpdateTrip
    
    var body: some View {
        Form {
            Section(header: Text("Trip")) {
                ZStack(alignment: .bottomTrailing) {
                    RouteView(startPoint: CLLocationCoordinate2D(latitude: trip.startingAddress.latitude,
                                                                 longitude: trip.startingAddress.longitude),
                              endPoint: CLLocationCoordinate2D(latitude: trip.endingAddress.latitude,
                                                               longitude: trip.endingAddress.longitude))
                    
                    HStack {
                        Text("\(trip.totalDistance.twoDigitPrecision) km")
                            .padding()
                    }
                    .background(Color("SearchTextFieldBackground"))
                    .cornerRadius(25)
                    .padding()
                }
                .frame(height: 310)
            }
            
            Section(header: Text("Addresses")) {
                AddressTileView(address: trip.startingAddress, title: "Starting address")
                AddressTileView(address: trip.endingAddress, title: "Ending address")
            }
            
            Section(header: Text("Informations")) {
                HStack {
                    Text("Date")
                    Spacer()
                    Text("\(trip.date.toDate?.dateOnly ?? "")")
                }
            }
            
            Section(header: Text("Missions")) {
                ForEach(trip.missions, id: \.self) { mission in
                    Text(mission)
                }
            }
            
            if let comment = trip.comment {
                Section(header: Text("Comments")) {
                    Text(comment)
                }
            }
        }
        .navigationTitle(Text("\(trip.startingAddress.city) → \(trip.endingAddress.city)"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $tripController.showUpdateTripView, content: {
            UpdateTripView(trip: $updateTrip, isAnUpdate: .constant(true))
        })
        .onAppear {
            updateTrip = trip.toUpdateTripFormat()
        }
        .toolbar {
            Button {
                tripController.showUpdateTripView = true
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
    }
}

struct DetailedTripView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTripView(trip: .constant(TripController.emptyTrip))
            .environmentObject(TripController(appController: AppController()))
    }
}
