//
//  LocationController.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import CoreLocation
import CoreLocationUI
import MapKit
import Mixpanel

final class LocationController: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: Public
    // MARK: Properties
    static let defaultMapPoint: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,
                                                                                                       longitude: 0),
                                                                        latitudinalMeters: 0,
                                                                        longitudinalMeters: 0)
    static let emptyAddress: Address = Address(roadName: "",
                                               streetNumber: "",
                                               complement: "",
                                               zipCode: "",
                                               city: "",
                                               country: "",
                                               latitude: 0.0,
                                               longitude: 0.0)
    
    @Published var region: MKCoordinateRegion = LocationController.defaultMapPoint
    @Published var addressLocated: String = ""
    @Published var address: Address = emptyAddress
    @Published var enteredAddress: String = ""
    @Published var searchingAddress: Bool = false
    
    // MARK: Methods
    /// Searching address
    func searchAddress() {
        searchingAddress = true
        
        if enteredAddress.isNotEmpty {
            findAddress()
        } else {
            getAddress()
        }
    }
    
    /// Centering map
    func centerMap(with address: Address) {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: address.latitude,
                                                                   longitude: address.longitude),
                                    latitudinalMeters: 750,
                                    longitudinalMeters: 750)
        getAddress()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                            longitude: location.coordinate.longitude),
                                             latitudinalMeters: 750,
                                             longitudinalMeters: 750)
            self.getAddress()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Mixpanel.mainInstance().track(event: "Unable to access user location")
    }
    
    /// Requesting location
    func requestLocation() {
        searchingAddress = true
        locationManager.requestLocation()
    }
    
    // MARK: Initialization
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: Private
    // MARK: Properties
    private let locationManager = CLLocationManager()
    
    // MARK: Method
    /// Finding address from the entered address
    private func findAddress() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(enteredAddress) { placemarks, _ in
            let placemark = placemarks?.first
            if let lat = placemark?.location?.coordinate.latitude,
               let lon = placemark?.location?.coordinate.longitude {
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat,
                                                                                longitude: lon),
                                                 latitudinalMeters: 750,
                                                 longitudinalMeters: 750)
                self.getAddress()
            } else {
                self.searchingAddress = false
                self.addressLocated = "No address found!"
            }
        }
    }
    
    /// Getting address from the location
    private func getAddress() {
        let geocoder = CLGeocoder()
        let addressLocation = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
        
        geocoder.reverseGeocodeLocation(addressLocation) { location, error in
            self.searchingAddress = false
            if error == nil,
               let placemarks = location,
               placemarks.count >= 1 {
                let mark = placemarks[0]
                self.address = Address(roadName: "\(mark.thoroughfare ?? "")",
                                       streetNumber: "\(mark.subThoroughfare ?? "")",
                                       complement: "",
                                       zipCode: "\(mark.postalCode ?? "")",
                                       city: "\(mark.locality ?? "")",
                                       country: "\(mark.country ?? "")",
                                       latitude: self.region.center.latitude,
                                       longitude: self.region.center.longitude)
                let addressLine1 = "\(self.address.streetNumber), \(self.address.roadName)"
                let addressLine2 = "\(self.address.zipCode), \(self.address.city)"
                self.addressLocated = "\(addressLine1) - \(addressLine2) - \(self.address.country)"
                if self.addressLocated == ",  - ,  - " {
                    self.addressLocated = "No address found!"
                }
                self.enteredAddress = ""
            } else {
                self.addressLocated = "No address found!"
            }
        }
    }
}
