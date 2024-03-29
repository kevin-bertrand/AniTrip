//
//  TripManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import Foundation

final class TripManager {
    // MARK: Public
    // MARK: Properties
    var trips: [Trip] { tripList.sorted { $0.date > $1.date }}
    var volunteerTrips: [Trip] { volunteerTripsList.sorted {$0.date > $1.date} }
    var threeLatestTrips: [Trip] { threeLatestTripsList.sorted { $0.date > $1.date }}
    var tripsChartPoints: [TripChartPoint] {
        tripsChartPointsList.sorted { $0.date.chartPointToDate < $1.date.chartPointToDate }
    }
    var news: News = News(distanceThisWeek: 0.0,
                          numberOfTripThisWeek: 0,
                          distanceThisYear: 0.0,
                          numberOfTripThisYear: 0,
                          distancePercentSinceLastYear: 0.0,
                          distancePercentSinceLastWeek: 0.0,
                          numberTripPercentSinceLastYear: 0.0,
                          numberTripPercentSinceLastWeek: 0.0)
    var pdfData: Data = Data()
    
    // MARK: Methods
    /// Getting trip list
    func getList(byUser user: User?, of volunteer: Volunteer? = nil) {
        guard let user = user, let userId = user.id else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        var params = NetworkConfigurations.getTripList.urlParams
        params.append(volunteer == nil ? "\(userId)" : "\(volunteer!.id)")
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.getTripList.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error) {
                if let statusCode = response?.statusCode {
                    switch statusCode {
                    case 200:
                        self.decodeTripList(data: data, ofVolunteer: ((volunteer == nil) ? false : true))
                    case 404:
                        Notification.AniTrip.gettingTripListError.sendNotification()
                    default:
                        Notification.AniTrip.unknownError.sendNotification()
                    }
                } else {
                    Notification.AniTrip.unknownError.sendNotification()
                }
            }
        }
    }
    
    /// Adding trip
    func add(trip: UpdateTrip, by user: User?) {
        guard let user = user else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        networkManager.request(urlParams: NetworkConfigurations.addTrip.urlParams,
                               method: NetworkConfigurations.addTrip.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: trip.toAddTripFormat()) { [weak self] _, response, error in
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error) {
                if let statusCode = response?.statusCode {
                    switch statusCode {
                    case 200:
                        self.getList(byUser: user)
                        Notification.AniTrip.addTripSuccess.sendNotification()
                    case 401:
                        Notification.AniTrip.notAuthorized.sendNotification()
                    default:
                        Notification.AniTrip.unknownError.sendNotification()
                    }
                } else {
                    Notification.AniTrip.unknownError.sendNotification()
                }
            }
        }
    }
    
    /// Updating an existing trip
    func update(trip: UpdateTrip, by user: User?) {
        guard let user = user else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        networkManager.request(urlParams: NetworkConfigurations.updateTrip.urlParams,
                               method: NetworkConfigurations.updateTrip.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: trip.toAddTripFormat()) { [weak self] _, response, error in
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error) {
                if let statusCode = response?.statusCode {
                    switch statusCode {
                    case 200:
                        self.getList(byUser: user)
                        Notification.AniTrip.updateTripSuccess.sendNotification()
                    case 401:
                        Notification.AniTrip.notAuthorized.sendNotification()
                    default:
                        Notification.AniTrip.unknownError.sendNotification()
                    }
                } else {
                    Notification.AniTrip.unknownError.sendNotification()
                }
            }
        }
    }
    
    /// Downloading informations when home view is loaded
    func threeLatestTrips(byUser user: User, filter: ChartFilter) {
        guard let userId = user.id else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        var params = NetworkConfigurations.getThreeLatestTrip.urlParams
        params.append("\(userId)")
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.getThreeLatestTrip.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error) {
                if let statusCode = response?.statusCode {
                    switch statusCode {
                    case 200:
                        self.decodeThreeLatestTrips(data: data, for: user, filter: filter)
                    case 404:
                        Notification.AniTrip.gettingTripListError.sendNotification()
                    default:
                        Notification.AniTrip.unknownError.sendNotification()
                    }
                } else {
                    Notification.AniTrip.unknownError.sendNotification()
                }
            }
        }
    }
    
    /// Download  trips chart point
    func downloadChartPoint(forUser user: User, filter: ChartFilter = .week) {
        guard let userId = user.id else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        var params = NetworkConfigurations.getChartPoints.urlParams
        params.append("\(filter.self)")
        params.append("\(userId)")
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.getChartPoints.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error),
               let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    self.decodeChartPoint(data: data, for: user)
                case 404:
                    Notification.AniTrip.homeInformationsDonwloadedError.sendNotification()
                default:
                    Notification.AniTrip.unknownError.sendNotification()
                }
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Downlaod home news informations
    func downloadNews(for user: User) {
        guard let userId = user.id else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        var params = NetworkConfigurations.getNews.urlParams
        params.append("\(userId)")
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.getNews.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] data, response, error in
            
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error),
               let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    self.decodeNews(data: data)
                case 404:
                    Notification.AniTrip.homeInformationsDonwloadedError.sendNotification()
                default:
                    Notification.AniTrip.unknownError.sendNotification()
                }
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Download trip to export
    func downloadPDF(with filters: TripFilterToExport, by user: User) {
        networkManager.request(urlParams: NetworkConfigurations.filterTripsToExport.urlParams,
                               method: NetworkConfigurations.filterTripsToExport.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: filters) { [weak self] data, response, error in
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error),
               let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data {
                self.pdfData = data
                Notification.AniTrip.pdfDownloaded.sendNotification()
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Deleting trip
    func delete(id: UUID, by user: User?) {
        guard let user = user else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        var params = NetworkConfigurations.deleteTrip.urlParams
        params.append("\(id)")
        
        networkManager.request(urlParams: params,
                               method: NetworkConfigurations.deleteTrip.method,
                               authorization: .authorization(bearerToken: user.token),
                               body: nil) { [weak self] _, response, error in
            if let self = self,
               self.networkManager.checkIfDeviceIsConnectedToInternet(with: error),
               let statusCode = response?.statusCode,
               statusCode == 200 {
                self.getList(byUser: user)
            } else {
                Notification.AniTrip.unknownError.sendNotification()
            }
        }
    }
    
    /// Disconnect user
    func disconnect() {
        tripList = []
        volunteerTripsList = []
        threeLatestTripsList = []
        tripsChartPointsList = []
    }
    
    // MARK: Initialization
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    // MARK: Private
    // MARK: Properties
    private var tripList: [Trip] = []
    private var volunteerTripsList: [Trip] = []
    private var threeLatestTripsList: [Trip] = []
    private let networkManager: NetworkManager
    private var tripsChartPointsList: [TripChartPoint] = []
    
    // MARK: Methods
    /// Decode three latest trips data
    private func decodeThreeLatestTrips(data: Data?, for user: User, filter: ChartFilter) {
        if let data = data,
           let trips = try? JSONDecoder().decode([Trip].self, from: data) {
            threeLatestTripsList = trips
            downloadChartPoint(forUser: user, filter: filter)
        } else {
            Notification.AniTrip.unknownError.sendNotification()
        }
    }
    
    /// Decode trip list data
    private func decodeTripList(data: Data?, ofVolunteer: Bool) {
        if let data = data,
           let trips = try? JSONDecoder().decode([Trip].self, from: data) {
            if ofVolunteer {
                volunteerTripsList = trips
                Notification.AniTrip.gettingVolunteerTripListSucess.sendNotification()
            } else {
                tripList = trips
                Notification.AniTrip.gettingTripListSucess.sendNotification()
            }
        } else {
            Notification.AniTrip.unknownError.sendNotification()
        }
    }
    
    /// Decode chart point data
    private func decodeChartPoint(data: Data?, for user: User) {
        if let data = data,
           let points = try? JSONDecoder().decode([TripChartPoint].self, from: data) {
            tripsChartPointsList = points
            downloadNews(for: user)
        } else {
            Notification.AniTrip.unknownError.sendNotification()
        }
    }
    
    /// Decode this week news data
    private func decodeNews(data: Data?) {
        if let data = data,
           let news = try? JSONDecoder().decode(News.self, from: data) {
            self.news = news
            Notification.AniTrip.homeInformationsDonwloaded.sendNotification()
        } else {
            Notification.AniTrip.unknownError.sendNotification()
        }
    }
}
