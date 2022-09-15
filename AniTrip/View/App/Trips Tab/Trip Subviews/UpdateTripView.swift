//
//  UpdateTripView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct UpdateTripView: View {
    @Binding var trip: UpdateTrip
    @Binding var isAnUpdate: Bool
    
    @State private var step = 1
    @State private var previousScreen = 1
    
    var body: some View {
        VStack {
            Group {
                switch step {
                case 1:
                    StartAddressView(step: $step, trip: $trip)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing),
                                                                                 removal: .move(edge: .leading)))
                case 2:
                    EndAddressView(step: $step, trip: $trip)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing),
                                                                                 removal: .move(edge: .leading)))
                case 3:
                    TripDistanceView(step: $step, trip: $trip)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing),
                                                                                 removal: .move(edge: .leading)))
                case 4:
                    TripDateView(step: $step, trip: $trip)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing),
                                                                                 removal: .move(edge: .leading)))
                case 5:
                    TripMissionsView(step: $step, trip: $trip)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing),
                                                                                 removal: .move(edge: .leading)))
                case 6:
                    TripCommentView(step: $step, trip: $trip, isAnUpdate: $isAnUpdate)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing),
                                                                                 removal: .move(edge: .leading)))
                default:
                    Text("Error")
                }
            }
        }
        .onChange(of: step) { newValue in
            previousScreen = newValue
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateTripView(trip: .constant(TripController.emptyUpdateTrip),
                       isAnUpdate: .constant(true))
    }
}
