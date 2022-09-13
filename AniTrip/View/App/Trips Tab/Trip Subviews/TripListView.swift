//
//  TripListView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct TripListView: View {
    @EnvironmentObject private var tripController: TripController
    
    @Binding var searchFilter: String
    @Binding var trips: [Trip]
    var canAddTrip = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    SearchTextFieldView(searchText: $searchFilter)
                    if canAddTrip {
                        Button {
                            tripController.showUpdateTripView = true
                        } label: {
                            Label("Add", systemImage: "plus.circle")
                        }
                        .padding(.horizontal)
                    }
                }
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
                }
            }
        }
    }
}

struct TripListView_Previews: PreviewProvider {
    static var previews: some View {
        TripListView(searchFilter: .constant(""), trips: .constant([]))
            .environmentObject(TripController(appController: AppController()))
    }
}
