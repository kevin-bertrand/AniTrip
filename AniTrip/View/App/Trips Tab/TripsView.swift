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
        Form {
            Section {
                SearchTextFieldView(searchText: $tripController.searchFilter)
            }.listRowBackground(Color.clear)
            
            Section {
                List {
                    ForEach(tripController.trips, id: \.id) { trip in
                        NavigationLink {
                            DetailedTripView(trip: trip)
                        } label: {
                            TripTileView(trip: trip)
                        }
                    }
                }
            }
        }
        .onAppear {
            tripController.getList(byUser: userController.connectedUser)
        }
        .toolbar {
            NavigationLink {
                AddTripView()
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
            .environmentObject(UserController())
    }
}
