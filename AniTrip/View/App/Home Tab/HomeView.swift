//
//  HomeView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Charts
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var tripController: TripController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        List {
            Section {
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        NewsTileView(title: "This week:", icon: Image(systemName: "car"), information: "\(tripController.numberOfTripThisWeek) trips")
                        NewsTileView(title: "This week", icon: Image("TripIcon"), information: "\(tripController.distanceThisWeek) km")
                    }
                    .padding(.vertical)
                }
                .listRowBackground(Color.clear)
            }
            
            Section {
                VStack {
                    HStack {
                        Text("Total distance")
                        Spacer()
                    }
                    
                    Chart {
                        ForEach(tripController.chartPoints, id: \.self) {
                            LineMark(x: .value("Date", $0.date), y: .value("Distance", $0.distance))
                            PointMark(x: .value("Date", $0.date), y: .value("Distance", $0.distance))
                        }
                    }
                    .frame(height: 300)
                    .padding(.vertical)
                }
            }
            
            Section {
                HStack {
                    Text("Three latest trips")
                    Spacer()
                }
                
                ForEach(tripController.threeLatestTrips, id: \.id) { trip in
                    NavigationLink {
                        DetailedTripView(trip: trip)
                    } label: {
                        TripTileView(trip: trip)
                    }
                }
            }
        }
        .onAppear {
            tripController.homeIsLoaded(byUser: userController.connectedUser)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController())
    }
}
