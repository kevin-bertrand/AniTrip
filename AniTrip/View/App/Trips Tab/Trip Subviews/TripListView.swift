//
//  TripListView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import SwiftUI

struct TripListView: View {
    @Binding var searchFilter: String
    @Binding var trips: [Trip]
    
    var body: some View {
        Form {
            Section {
                SearchTextFieldView(searchText: $searchFilter)
            }.listRowBackground(Color.clear)
            
            Section {
                List {
                    ForEach(trips, id: \.id) { trip in
                        NavigationLink {
                            DetailedTripView(trip: trip)
                        } label: {
                            TripTileView(trip: trip)
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
