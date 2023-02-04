//
//  TripListView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct TripListView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    
    @Binding var searchFilter: String
    @Binding var trips: [Trip]
    
    @State private var showUpdateTripView: Bool = false
    @State private var selectedTrip: UpdateTrip = TripController.emptyUpdateTrip
    
    var body: some View {
        Form {
            Section {
                SearchTextFieldView(searchText: $searchFilter)
            }.listRowBackground(Color.clear)
            
            Section {
                List {
                    ForEach($trips, id: \.id) { $trip in
                        NavigationLink {
                            DetailedTripView(trip: $trip)
                        } label: {
                            TripTileView(trip: $trip.wrappedValue)
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            tripController.delete(tripId: trips[index].id, byUser: userController.connectedUser)
                        }
                    }
                }
            }
        }
        .syncBool($showUpdateTripView, with: $tripController.showUpdateTripView)
        .syncUpdateTrip($selectedTrip, with: $tripController.updateTrip)
        .onAppear {
            selectedTrip = TripController.emptyUpdateTrip
        }
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView(searchFilter: .constant(""), trips: .constant([]))
            .environmentObject(TripController(appController: AppController()))
    }
}
