//
//  LocationManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import CoreLocation
import CoreLocationUI
import Foundation
import MapKit
import SwiftUI

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.837062, longitude: 2.711611), latitudinalMeters: 250, longitudinalMeters: 250)
    @Published var addressLocated: String = ""
    
    override init() {
        super.init()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first?.coordinate else { return }
        
        location = loc
        region.center = loc
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getAddress(completionHandler: @escaping ((Address?)->Void)) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        
        geocoder.reverseGeocodeLocation(location) { location, error in
            if error == nil,
                 let placemarks = location,
                 placemarks.count >= 1  {
                let pm = placemarks[0]
                let address = Address(roadName: "\(pm.thoroughfare ?? "")", streetNumber: "\(pm.subThoroughfare ?? "")", complement: "", zipCode: "\(pm.postalCode ?? "")", city: "\(pm.locality ?? "")", country: "\(pm.country ?? "")")
                self.addressLocated = "\(address.streetNumber), \(address.roadName) - \(address.zipCode), \(address.city) - \(address.country)"
                
                completionHandler(address)
            } else {
                self.addressLocated = "No address found!"
                completionHandler(nil)
            }
        }
    }
}
