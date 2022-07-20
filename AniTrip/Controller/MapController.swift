//
//  MapController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import CoreLocation
import Foundation
import MapKit

final class MapController: ObservableObject {
    // MARK: Public
    // MARK: Properties
    static let defaultMapPoint: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
    static let emptyAddress: Address = Address(roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0.0, longitude: 0.0)
}
