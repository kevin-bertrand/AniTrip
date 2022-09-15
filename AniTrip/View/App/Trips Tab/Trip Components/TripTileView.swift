//
//  TripTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct TripTileView: View {
    let trip: Trip
    
    var body: some View {
        HStack {
            Image("TripIcon")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.trailing)
            VStack(alignment: .leading) {
                Text("\(trip.startingAddress.city) → \(trip.endingAddress.city)")
                    .bold()
                    .font(.title2)
                Text(trip.date.toDate?.dateOnly ?? "No date")
                Text("\(trip.totalDistance.twoDigitPrecision) km")
            }
        }
    }
}

struct TripTileView_Previews: PreviewProvider {
    static var previews: some View {
        TripTileView(trip: TripController.emptyTrip)
    }
}
