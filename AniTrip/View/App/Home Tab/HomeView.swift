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
    @EnvironmentObject var volunteersController: VolunteersController
    
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
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Distance")
                                .font(.title2.bold())
                            Text("For last \(tripController.chartFilter == .week ? "7 days" : tripController.chartFilter == .month ? "1 month" : "1 year")")
                        }
                        Spacer()
                        Picker("", selection: $tripController.chartFilter) {
                            Text(ChartFilter.week.rawValue).tag(ChartFilter.week)
                            Text(ChartFilter.month.rawValue).tag(ChartFilter.month)
                            Text(ChartFilter.year.rawValue).tag(ChartFilter.year)
                        }.pickerStyle(.menu)
                    }
                    
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
        .onChange(of: tripController.chartFilter, perform: { _ in
            tripController.downlaodChartPoint(byUser: userController.connectedUser)
        })
        .onAppear {
            tripController.homeIsLoaded(byUser: userController.connectedUser)
        }
        .sheet(isPresented: $volunteersController.displayActivateAccount) {
            ActivateAccountView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TripController(appController: AppController()))
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(VolunteersController(appController: AppController()))
    }
}
