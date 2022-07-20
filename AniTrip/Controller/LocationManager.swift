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
    @Published var enteredAddress: String = ""
    
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
        let addressLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        
        geocoder.reverseGeocodeLocation(addressLocation) { location, error in
            if error == nil,
               let placemarks = location,
               placemarks.count >= 1  {
                let pm = placemarks[0]
                let address = Address(roadName: "\(pm.thoroughfare ?? "")", streetNumber: "\(pm.subThoroughfare ?? "")", complement: "", zipCode: "\(pm.postalCode ?? "")", city: "\(pm.locality ?? "")", country: "\(pm.country ?? "")", latitude: self.region.center.latitude, longitude: self.region.center.longitude)
                self.addressLocated = "\(address.streetNumber), \(address.roadName) - \(address.zipCode), \(address.city) - \(address.country)"
                
                completionHandler(address)
            } else {
                self.addressLocated = "No address found!"
                completionHandler(nil)
            }
        }
    }
    
    func searchAddress(completionHandler: @escaping ((Address?)->Void)) {
        if enteredAddress.isNotEmpty {
            getAddressFromAddress { address in
                completionHandler(address)
            }
        } else {
            getAddress { address in
                completionHandler(address)
            }
        }
    }
    
    func getAddressFromAddress(completionHandler: @escaping ((Address?)->Void)) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(enteredAddress) { placemarks, error in
            let placemark = placemarks?.first
            if let lat = placemark?.location?.coordinate.latitude, let lon = placemark?.location?.coordinate.longitude {
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 750, longitudinalMeters: 750)
                self.getAddress { address in
                    completionHandler(address)
                }
            } else {
                self.addressLocated = "No address found!"
                completionHandler(nil)
            }
        }
    }
}
