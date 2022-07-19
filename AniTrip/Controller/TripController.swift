//
//  TripController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

final class TripController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    @Published var trips: [Trip] = []
    @Published var searchFilter: String = "" {
        didSet {
            filterList()
        }
    }
    
    // New trip properties
    @Published var newTrip: NewTrip = NewTrip(date: .now, missions: [], comment: "", totalDistance: "", startingAddress: MapController.emptyAddress, endingAddress: MapController.emptyAddress)
    
    // Home informations
    @Published var threeLatestTrips: [Trip] = []
    var distanceThisWeek: Double = 0.0
    var numberOfTripThisWeek: Int = 0
    var chartPoints: [TripChartPoint] = []
    
    // MARK: Methods
    /// Getting trip list
    func getList(byUser user: User?) {
        tripManager.getList(byUser: user)
    }
    
    /// Adding a new trip
    func add(byUser user: User?) {
        appController.setLoadingInProgress(withMessage: "Adding trip in progress...")
        
        tripManager.add(trip: newTrip, by: user)
    }
    
    /// Download informations when home view is loaded
    func homeIsLoaded(byUser user: User?) {
        tripManager.dowloadHomeInformations(byUser: user)
    }
    
    // MARK: Initialization
    init(appController: AppController) {
        self.appController = appController
        
        // Configure getting trip list notifications
        configureNotification(for: Notification.AniTrip.gettingTripListSucess.notificationName)
        configureNotification(for: Notification.AniTrip.gettingTripListError.notificationName)
        
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
            case Notification.AniTrip.gettingTripListError.notificationName,
                 Notification.AniTrip.homeInformationsDonwloadedError.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage)
            case Notification.AniTrip.addTripSuccess.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage, mustReturnToPreviousView: true)
            case Notification.AniTrip.homeInformationsDonwloaded.notificationName:
                threeLatestTrips = tripManager.threeLatestTrips
                print(threeLatestTrips)
                distanceThisWeek = tripManager.distanceThisWeek
                numberOfTripThisWeek = tripManager.numberOfTripsThisWeek
                chartPoints = tripManager.tripsChartPoints
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
}
