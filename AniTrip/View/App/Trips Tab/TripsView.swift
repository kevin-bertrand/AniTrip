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
    
    var body: some View {
        TripListView(searchFilter: $tripController.searchFilter, trips: $tripController.trips)
        .onAppear {
            tripController.getList(byUser: userController.connectedUser)
        }
        .sheet(isPresented: $tripController.showUpdateTripView, content: {
            UpdateTripView(trip: $tripController.newTrip)
        })
        .toolbar {
            Button {
                tripController.showUpdateTripView = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController(appController: AppController()))
    }
}
