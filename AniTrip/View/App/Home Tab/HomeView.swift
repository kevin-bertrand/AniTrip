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
    @EnvironmentObject private var tripController: TripController
    @EnvironmentObject private var userController: UserController
    @EnvironmentObject private var volunteersController: VolunteersController
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("News")
                        .font(.title2.bold())
                        .padding(.horizontal, 30)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            Group {
                                NewsTileView(title: NSLocalizedString("This week", comment: ""),
                                             icon: Image(systemName: "car"),
                                             information: "\(tripController.news.numberOfTripThisWeek) trips",
                                             percent: tripController.news.distancePercentSinceLastWeek,
                                             comparaison: "week")
                                NewsTileView(title: NSLocalizedString("This week", comment: ""),
                                             icon: Image("TripIcon"),
                                             information: "\(tripController.news.distanceThisWeek.twoDigitPrecision) km",
                                             percent: tripController.news.numberTripPercentSinceLastWeek,
                                             comparaison: "week")
                                NewsTileView(title: NSLocalizedString("This year", comment: ""),
                                             icon: Image(systemName: "car"),
                                             information: "\(tripController.news.numberOfTripThisYear) trips",
                                             percent: tripController.news.distancePercentSinceLastYear,
                                             comparaison: "year")
                            }.padding(.leading, 10)
                            
                            NewsTileView(title: NSLocalizedString("This year", comment: ""),
                                         icon: Image("TripIcon"),
                                         information: "\(tripController.news.distanceThisYear.twoDigitPrecision) km",
                                         percent: tripController.news.numberTripPercentSinceLastYear,
                                         comparaison: "year")
                                .padding(.horizontal, 10)
                        }
                        .padding(.vertical)
                    }
                    
                }
            }
            .listRowBackground(Color.clear)
            .padding(.horizontal, -25)
            
            Section {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Distance")
                                .font(.title2.bold())
                            Text(getChartSubtitle())
                        }
                        Spacer()
                        Picker("", selection: $tripController.chartFilter) {
                            Text(ChartFilter.week.rawValue).tag(ChartFilter.week)
                            Text(ChartFilter.month.rawValue).tag(ChartFilter.month)
                            Text(ChartFilter.year.rawValue).tag(ChartFilter.year)
                        }.pickerStyle(.menu)
                    }
                    
                    if tripController.chartPoints.dataSets.dataPoints.isEmpty
                        || tripController.chartPoints.dataSets.dataPoints.allSatisfy { $0.value == 0.0 } {
                        Text("No data. Add a new trip to see this chart!")
                            .font(.body.bold())
                            .foregroundColor(.red)
                    } else {
                        LineChart(chartData: tripController.chartPoints)
                            .pointMarkers(chartData: tripController.chartPoints)
                            .touchOverlay(chartData: tripController.chartPoints, specifier: "%.0f km")
                            .xAxisGrid(chartData: tripController.chartPoints)
                            .yAxisGrid(chartData: tripController.chartPoints)
                            .xAxisLabels(chartData: tripController.chartPoints)
                            .yAxisLabels(chartData: tripController.chartPoints)
                            .floatingInfoBox(chartData: tripController.chartPoints)
                            .frame(minWidth: 150,
                                   maxWidth: 900,
                                   minHeight: 150,
                                   idealHeight: 250,
                                   maxHeight: 500,
                                   alignment: .center)
                            .padding(.top, 25)
                    }
                }.padding(5)
            }
            
            Section {
                HStack {
                    Text("Three latest trips")
                    Spacer()
                }
                
                ForEach($tripController.threeLatestTrips, id: \.id) { $trip in
                    NavigationLink {
                        DetailedTripView(trip: $trip)
                    } label: {
                        TripTileView(trip: $trip.wrappedValue)
                    }
                }
            }
        }
        .listStyle(.grouped)
        .onChange(of: tripController.chartFilter, perform: { _ in
            tripController.downlaodChartPoint(byUser: userController.connectedUser)
        })
        .sheet(isPresented: $volunteersController.displayActivateAccount) {
            ActivateAccountView()
        }
        .onAppear {
            if let connectedUser = userController.connectedUser {
                tripController.homeIsLoaded(byUser: connectedUser)
            }
        }
    }
    
    private func getChartSubtitle() -> String {
        switch tripController.chartFilter {
        case .year:
            return NSLocalizedString("For last 1 year", comment: "")
        case .month:
            return NSLocalizedString("For last 1 month", comment: "")
        case .week:
            return NSLocalizedString("For last 7 days", comment: "")
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
