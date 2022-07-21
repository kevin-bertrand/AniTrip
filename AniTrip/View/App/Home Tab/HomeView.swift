//
//  HomeView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Charts
import SwiftUI
import SwiftUICharts

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
                VStack(alignment: .leading) {
                    Text("Distance")
                        .font(.title2.bold())
                    Text("For last 7 days")
                    LineChart(chartData: tripController.chartPoints)
                        .pointMarkers(chartData: tripController.chartPoints)
                        .touchOverlay(chartData: tripController.chartPoints, specifier: "%.0f km")
                        .xAxisGrid(chartData: tripController.chartPoints)
                        .yAxisGrid(chartData: tripController.chartPoints)
                        .xAxisLabels(chartData: tripController.chartPoints)
                        .yAxisLabels(chartData: tripController.chartPoints)
                        .floatingInfoBox(chartData: tripController.chartPoints)
                        .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 250, maxHeight: 500, alignment: .center)
                        .padding(.top, 25)
                }.padding(5)
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
        .sheet(isPresented: $userController.displayActivateAccount) {
            ActivateAccountView()
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
