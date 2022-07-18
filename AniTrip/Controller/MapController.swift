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
    static let emptyAddress: Address = Address(roadName: "", roadType: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "")

    // MARK: Methods
    /// Getting coordinates of a given address
    func getCoordinatesForAddress(_ address: Address?, completionHandler: @escaping ((CLLocationCoordinate2D?, MKCoordinateRegion?) -> Void)) {        
        guard let address = address else {
            completionHandler(nil, nil)
            return
        }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(address.streetNumber), \(address.roadType) \(address.roadName) \(address.zipCode), \(address.city) \(address.country)") { placemarks, error in
            let placemark = placemarks?.first
            if let lat = placemark?.location?.coordinate.latitude, let lon = placemark?.location?.coordinate.longitude {
                completionHandler(CLLocationCoordinate2D(latitude: lat, longitude: lon), MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 750, longitudinalMeters: 750))
            } else {
                completionHandler(nil, nil)
            }
        }
    }
    
    // MARK: Private
    // MARK: Properties
    
    // MARK: Methods
}
