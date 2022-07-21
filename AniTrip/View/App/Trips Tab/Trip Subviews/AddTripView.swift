//
//  AddTripView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import SwiftUI

struct AddTripView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    @State private var step = 1
    @State private var previousScreen = 1
    
    var body: some View {
        VStack {
            Group {
                switch step {
                case 1:
                    AddingStartAddressView(step: $step)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 2:
                    AddingEndAddressView(step: $step)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 3:
                    NewTripDistanceView(step: $step)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 4:
                    NewTripDateView(step: $step)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 5:
                    NewTripMissionsView(step: $step)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case 6:
                    NewTripCommentView(step: $step)
                        .transition(previousScreen > step ? .slide : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                default:
                    Text("Error")
                }
            }
        }
        .onAppear {
            tripController.newTrip = NewTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationManager.emptyAddress, endingAddress: LocationManager.emptyAddress)
        }
        .onChange(of: step) { newValue in
            previousScreen = newValue
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController())
    }
}
