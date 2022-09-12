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
import PDFKit

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
    @Published var showUpdateTripView: Bool = false
    @Published var newMission: String = ""
    @Published var newTrip: UpdateTrip = UpdateTrip(id: UUID(uuid: UUID_NULL), date: Date(), missions: [], comment: "", totalDistance: "", startingAddress: LocationController.emptyAddress, endingAddress: LocationController.emptyAddress) {
        willSet {
            if newValue.startingAddress != newTrip.startingAddress || newValue.endingAddress != newTrip.endingAddress {
                newTripIsUpdated = true
            } else {
                newTripIsUpdated = false
            }
        }
        didSet {
            if newTripIsUpdated {
                calculteDrivingDistance()
            }
        }
    }
    @Published var loadingDistance: Bool = false
    private var newTripIsUpdated = false
    
    // Home informations
    @Published var threeLatestTrips: [Trip] = []
    @Published var chartFilter: ChartFilter = .week
    @Published var news: News = News(distanceThisWeek: 0.0, numberOfTripThisWeek: 0, distanceThisYear: 0.0, numberOfTripThisYear: 0, distancePercentSinceLastYear: 0.0, distancePercentSinceLastWeek: 0.0, numberTripPercentSinceLastYear: 0.0, numberTripPercentSinceLastWeek: 0.0)
    @Published var chartPoints: LineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    
    // Export trip
    @Published var startFilterDate: Date = Date()
    @Published var endFilterDate: Date = Date()
    var tripToExport: TripToExportInformations = .init(userLastname: "", userFirstname: "", userPhone: "", userEmail: "", startDate: "", endDate: "", totalDistance: 0.0, trips: [])
    
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
        showUpdateTripView = false
        appController.setLoadingInProgress(withMessage: "Adding trip in progress...")
        
        tripManager.add(trip: newTrip, by: user)
    }
    
    /// Update a trip
    func update(trip: UpdateTrip, byUser user: User?) {
        showUpdateTripView = false
        appController.setLoadingInProgress(withMessage: "Updating trip in progress...")
        
        tripManager.update(trip: trip, by: user)
    }
    
    /// Download informations when home view is loaded
    func homeIsLoaded(byUser user: User?) {
        tripManager.threeLatestTrips(byUser: user, filter: chartFilter)
    }
    
    /// Adding a mission to a new trip
    func addMission() {
        newTrip.missions.append(newMission)
    }
    
    /// Downlaod chart point
    func downlaodChartPoint(byUser user: User?) {
        guard let user = user else { return }
        tripManager.downloadChartPoint(forUser: user, filter: chartFilter)
    }
    
    /// Download data to export
    func downloadDataToExport(byUser user: User?, for userId: UUID?) {
        guard let user = user, let userId = userId else { return }
        appController.setLoadingInProgress(withMessage: "Download in progress...")
        
        let filters = TripFilterToExport(userID: userId, startDate: startFilterDate.iso8601, endDate: endFilterDate.iso8601)
        
        tripManager.downloadTripToExport(with: filters, by: user)
    }
    
    /// Export data to PDF
    func exportToPDF() {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("SwiftUI.pdf")
        
        //Normal width
        let width: CGFloat = 8.5 * 72.0
        //Estimate the height of your view
        let height: CGFloat = 1000
        let charts = TripsExportView(tripController: self, exportData: tripToExport)
        
        let pdfVC = UIHostingController(rootView: charts)
        pdfVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        pdfVC.view.backgroundColor = .white
        pdfVC.view.tintColor = .black
        
        //Render the view behind all other views
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        rootVC?.addChild(pdfVC)
        rootVC?.view.insertSubview(pdfVC.view, at: 0)
        
        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: height))
        
        let alertMessage: String
        let alertTitle: String
        
        do {
            try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in
                context.beginPage()
                pdfVC.view.layer.render(in: context.cgContext)
            })
            alertMessage = "Export success"
            alertTitle = "Success"
        } catch {
            print("Could not create PDF file: \(error)")
            alertMessage = "Cannot procceed to the export!"
            alertTitle = "Error"
        }
        
        pdfVC.view.removeFromSuperview()
        appController.showAlertView(withMessage: alertMessage, andTitle: alertTitle)
    }
    
    /// Disconnect user
    func disconnect() {
        DispatchQueue.main.async {
            self.tripManager.disconnect()
            self.trips = []
            self.volunteerTripList = []
            self.threeLatestTrips = []
            self.news = News(distanceThisWeek: 0.0, numberOfTripThisWeek: 0, distanceThisYear: 0.0, numberOfTripThisYear: 0, distancePercentSinceLastYear: 0.0, distancePercentSinceLastWeek: 0.0, numberTripPercentSinceLastYear: 0.0, numberTripPercentSinceLastWeek: 0.0)
            self.chartPoints = LineChartData(dataSets: LineDataSet(dataPoints: []))
        }
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
        
        // Configure updating trip notification
        configureNotification(for: Notification.AniTrip.updateTripSuccess.notificationName)
        
        // Configure home informations notifications
        configureNotification(for: Notification.AniTrip.homeInformationsDonwloaded.notificationName)
        configureNotification(for: Notification.AniTrip.homeInformationsDonwloadedError.notificationName)
        
        // Configure export data notifications
        configureNotification(for: Notification.AniTrip.exportDataDownloaded.notificationName)
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
            
            switch notificationName {
            case Notification.AniTrip.gettingTripListSucess.notificationName:
                self.trips = self.tripManager.trips
            case Notification.AniTrip.gettingVolunteerTripListSucess.notificationName:
                self.volunteerTripList = self.tripManager.volunteerTrips
            case Notification.AniTrip.gettingTripListError.notificationName,
                Notification.AniTrip.homeInformationsDonwloadedError.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Error")
            case Notification.AniTrip.addTripSuccess.notificationName,
                Notification.AniTrip.updateTripSuccess.notificationName:
                self.appController.showAlertView(withMessage: notificationMessage, andTitle: "Success")
            case Notification.AniTrip.homeInformationsDonwloaded.notificationName:
                threeLatestTrips = tripManager.threeLatestTrips
                self.news = tripManager.news
                chartPoints = getChartData(from: tripManager.tripsChartPoints)
            case Notification.AniTrip.exportDataDownloaded.notificationName:
                tripToExport = tripManager.tripToExportInformation
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
        loadingDistance = true
        let request = MKDirections.Request()
        let source = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: newTrip.startingAddress.latitude, longitude: newTrip.startingAddress.longitude))
        let destination = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: newTrip.endingAddress.latitude, longitude: newTrip.endingAddress.longitude))
        
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            DispatchQueue.main.async {
                self.loadingDistance = false
            }
            if let response = response,
               let route = response.routes.first {
                self.newTrip.totalDistance = "\((route.distance/1000.0).twoDigitPrecision)"
            }
        }
    }
    
    /// Configure data char
    private func getChartData(from data: [TripChartPoint]) -> LineChartData {
        var chartData: [LineChartDataPoint] = []
        
        for point in data {
            chartData.append(LineChartDataPoint(value: point.distance, xAxisLabel: point.date, description: point.date))
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
        
        return LineChartData(dataSets       : data,
                             metadata       : metadata,
                             chartStyle     : chartStyle)
    }
}
