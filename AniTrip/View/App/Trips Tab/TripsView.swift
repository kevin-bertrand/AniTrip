//
//  TripsView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct TripsView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    
    @State private var showUpdateTripView: Bool = false
    @State private var selectedTrip: UpdateTrip = TripController.emptyUpdateTrip
    @State private var searchFilter: String = ""
    @State private var trips: [Trip] = []
    
    var body: some View {
        TripListView(searchFilter: $searchFilter, trips: $trips)
            .onAppear {
                tripController.getList(byUser: userController.connectedUser)
            }
            .sheet(isPresented: $showUpdateTripView, content: {
                UpdateTripView(trip: $selectedTrip, isAnUpdate: .constant(false))
            })
            .toolbar {
                Button {
                    tripController.showUpdateTripView = true
                } label: {
                    Label("Add", systemImage: "plus.circle")
                }
            }
            .syncBool($showUpdateTripView, with: $tripController.showUpdateTripView)
            .syncUpdateTrip($selectedTrip, with: $tripController.updateTrip)
            .syncText($searchFilter, with: $tripController.searchFilter)
            .onReceive(tripController.$trips, perform: { trips = $0 })
            .onAppear {
                selectedTrip = TripController.emptyUpdateTrip
            }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TripsView()
                .environmentObject(TripController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
