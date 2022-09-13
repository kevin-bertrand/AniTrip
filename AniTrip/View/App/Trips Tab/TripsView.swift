//
//  TripsView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct TripsView: View {
    @EnvironmentObject private var tripController: TripController
    @EnvironmentObject private var userController: UserController
    
    var body: some View {
        TripListView(searchFilter: $tripController.searchFilter, trips: $tripController.trips, canAddTrip: true)
            .onAppear {
                tripController.getList(byUser: userController.connectedUser)
            }
            .sheet(isPresented: $tripController.showUpdateTripView, content: {
                UpdateTripView(trip: $tripController.newTrip, isAnUpdate: .constant(false))
            })
            .toolbar {
                NavigationLink {
                    TripsExportFilterView(userToExportId: userController.connectedUser?.id)
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                }
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
