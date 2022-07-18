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
    var trips: [Trip] {tripList.sorted { $0.date > $1.date }}
    
    // MARK: Methods
    /// Getting trip list
    func getList(byUser user: User?) {
        guard let user = user, let userId = user.id else {
            Notification.AniTrip.unknownError.sendNotification()
            return
        }
        
        var params = NetworkConfigurations.getTripList.urlParams
        params.append("\(userId)")
        
        networkManager.request(urlParams: params, method: NetworkConfigurations.getTripList.method, authorization: .authorization(bearerToken: user.token), body: nil) { [weak self] data, response, error in
            if let self = self,
               let statusCode = response?.statusCode {
                switch statusCode {
                case 200:
                    self.decodeTripList(data: data)
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
    
    // MARK: Private
    // MARK: Properties
    private var tripList: [Trip] = []
    private let networkManager: NetworkManager = NetworkManager()
    
    // MARK: Methods
    /// Decode trip list data
    private func decodeTripList(data: Data?) {
        if let data = data,
           let trips = try? JSONDecoder().decode([Trip].self, from: data) {
            tripList = trips
            Notification.AniTrip.gettingTripListSucess.sendNotification()
        } else {
            Notification.AniTrip.unknownError.sendNotification()
        }
    }
}
