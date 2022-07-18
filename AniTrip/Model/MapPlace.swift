//
//  MapPlace.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import CoreLocation
import Foundation

struct MapPlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), lat: Double, lon: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    init(id: UUID = UUID(), location: CLLocationCoordinate2D) {
        self.id = id
        self.location = location
    }
}
