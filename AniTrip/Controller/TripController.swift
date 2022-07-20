//
//  TripController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation
import MapKit
import SwiftUI
import SwiftUICharts

final class TripController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    @Published var trips: [Trip] = []
    @Published var searchFilter: String = "" {
        didSet {
            filterList()
        }
    }
    
    /// Volunteer trip list
    @Published var volunteerTripList: [Trip] = []
    @Published var volunteerSearchFilter: String = "" {
        didSet {
            filterVolunteerList()
        }
    }
    
    // New trip properties
    @Published var showAddNewTripView: Bool = false
    @Published var newMission: String = ""
    @Published var newTrip: NewTrip = NewTrip(date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: MapController.emptyAddress, endingAddress: MapController.emptyAddress) {
        didSet {
            calculteDrivingDistance()
        }
    }
    
    // Home informations
    @Published var threeLatestTrips: [Trip] = []
    var distanceThisWeek: Double = 0.0
    var numberOfTripThisWeek: Int = 0
    var chartPoints: LineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    
    // MARK: Methods
    /// Getting trip list
    func getList(byUser user: User?) {
        tripManager.getList(byUser: user)
    }
    
    /// Getting volunteer trip list
    func getList(byUser user: User?, for volunteer: Volunteer) {
        tripManager.getList(byUser: user, of: volunteer)
    }
    
    /// Adding a new trip
    func add(byUser user: User?) {
        showAddNewTripView = false
        appController.setLoadingInProgress(withMessage: "Adding trip in progress...")
        
        tripManager.add(trip: newTrip, by: user)
    }
    
    /// Download informations when home view is loaded
    func homeIsLoaded(byUser user: User?) {
        tripManager.dowloadHomeInformations(byUser: user)
    }
    
    /// Adding a mission to a new trip
    func addMission() {
        newTrip.missions.append(newMission)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure getting trip list notifications
        configureNotification(for: Notification.AniTrip.gettingTripListSucess.notificationName)
        configureNotification(for: Notification.AniTrip.gettingTripListError.notificationName)
        configureNotification(for: Notification.AniTrip.gettingVolunteerTripListSucess.notificationName)
        
        // Configure adding trip notification
        configureNotification(for: Notification.AniTrip.addTripSuccess.notificationName)
        
        // Configure home informations notifications
        configureNotification(for: Notification.AniTrip.homeInformationsDonwloaded.notificationName)
        configureNotification(for: Notification.AniTrip.homeInformationsDonwloadedError.notificationName)
    }
    
    // MARK: Private
    // MARK: Properties
    private let tripManager: TripManager = TripManager()
    private var appController: AppController
    private let mapController: MapController = MapController()
    
    // MARK: Methods
    /// Configure notification
    private func configureNotification(for name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(processNotification), name: name, object: nil)
    }
    
    /// Initialise all notification for this controller
    @objc private func processNotification(_ notification: Notification) {
        if let notificationName = notification.userInfo?["name"] as? Notification.Name,
           let notificationMessage = notification.userInfo?["message"] as? String {
            appController.resetLoadingInProgress()
            objectWillChange.send()
            
            switch notificationName {
            case Notification.AniTrip.gettingTripListSucess.notificationName:
                self.trips = self.tripManager.trips
            case Notification.AniTrip.gettingVolunteerTripListSucess.notificationName:
                self.volunteerTripList = self.tripManager.volunteerTrips
            case Notification.AniTrip.gettingTripListError.notificationName,
                Notification.AniTrip.homeInformationsDonwloadedError.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage)
            case Notification.AniTrip.addTripSuccess.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage, mustReturnToPreviousView: true)
            case Notification.AniTrip.homeInformationsDonwloaded.notificationName:
                threeLatestTrips = tripManager.threeLatestTrips
                distanceThisWeek = tripManager.distanceThisWeek
                numberOfTripThisWeek = tripManager.numberOfTripsThisWeek
                chartPoints = getChartData(from: tripManager.tripsChartPoints)
            default: break
            }
        }
    }
    
    /// Filter trip list
    private func filterList() {
        if searchFilter.isEmpty {
            trips = tripManager.trips
        } else {
            trips = tripManager.trips.filter { !($0.missions.filter {$0.localizedCaseInsensitiveContains(searchFilter)}).isEmpty || $0.comment?.localizedCaseInsensitiveContains(searchFilter) ?? false || $0.startingAddress.city.localizedCaseInsensitiveContains(searchFilter) || $0.startingAddress.roadName.localizedCaseInsensitiveContains(searchFilter) || $0.endingAddress.city.localizedCaseInsensitiveContains(searchFilter) || $0.endingAddress.roadName.localizedCaseInsensitiveContains(searchFilter) }
        }
    }
    
    /// Filter vounteer trip list
    private func filterVolunteerList() {
        if volunteerSearchFilter.isEmpty {
            volunteerTripList = tripManager.trips
        } else {
            volunteerTripList = tripManager.trips.filter { !($0.missions.filter {$0.localizedCaseInsensitiveContains(searchFilter)}).isEmpty || $0.comment?.localizedCaseInsensitiveContains(searchFilter) ?? false || $0.startingAddress.city.localizedCaseInsensitiveContains(searchFilter) || $0.startingAddress.roadName.localizedCaseInsensitiveContains(searchFilter) || $0.endingAddress.city.localizedCaseInsensitiveContains(searchFilter) || $0.endingAddress.roadName.localizedCaseInsensitiveContains(searchFilter) }
        }
    }
    
    /// Calculate the distance between 2 points
    private func calculteDrivingDistance() {
        let request = MKDirections.Request()
        let source = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: newTrip.startingAddress.latitude, longitude: newTrip.startingAddress.longitude))
        let destination = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: newTrip.endingAddress.latitude, longitude: newTrip.endingAddress.longitude))
        
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        
        request.transportType = .automobile
        
        request.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let response = response,
               let route = response.routes.first {
                self.newTrip.totalDistance = "\((route.distance/1000.0).twoDigitPrecision)"
            }
        }
    }
    
    private func getChartData(from data: [TripChartPoint]) -> LineChartData {
        var chartData: [LineChartDataPoint] = []
        
        for point in data {
            chartData.append(LineChartDataPoint(value: point.distance, xAxisLabel: point.date.toDate?.dayName, description: point.date.toDate?.dateOnly))
        }
        
        let data = LineDataSet(dataPoints: chartData,
                               legendTitle: "Distance",
                               pointStyle: PointStyle(),
                               style: LineStyle(lineColour: ColourStyle(colour: .accentColor), lineType: .curvedLine))
        
        let metadata   = ChartMetadata(title: "Distance", subtitle: "For last 7 days")
        
        let gridStyle  = GridStyle(numberOfLines: 7,
                                   lineColour   : Color(.lightGray).opacity(0.5),
                                   lineWidth    : 1,
                                   dash         : [8],
                                   dashPhase    : 0)
        
        let chartStyle = LineChartStyle(infoBoxPlacement    : .floating,
                                        infoBoxBorderColour : Color.primary,
                                        infoBoxBorderStyle  : StrokeStyle(lineWidth: 1),
                                        markerType          : .vertical(attachment: .line(dot: .style(DotStyle()))),
                                        xAxisGridStyle      : gridStyle,
                                        xAxisLabelPosition  : .bottom,
                                        xAxisLabelColour    : Color.primary,
                                        xAxisLabelsFrom     : .chartData(),
                                        yAxisGridStyle      : gridStyle,
                                        yAxisLabelPosition  : .leading,
                                        yAxisLabelColour    : Color.primary,
                                        yAxisNumberOfLabels : 7,
                                        baseline            : .minimumWithMaximum(of: 0),
                                        globalAnimation     : .easeOut(duration: 1))
        
        objectWillChange.send()
        return LineChartData(dataSets       : data,
                             metadata       : metadata,
                             chartStyle     : chartStyle)
    }
}
