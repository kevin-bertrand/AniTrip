//
//  LocationManager.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: Public
    // MARK: Properties
    static let defaultMapPoint: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 0, longitudinalMeters: 0)
    static let emptyAddress: Address = Address(roadName: "", streetNumber: "", complement: "", zipCode: "", city: "", country: "", latitude: 0.0, longitude: 0.0)
    
    @Published var region: MKCoordinateRegion = LocationManager.defaultMapPoint
    @Published var addressLocated: String = ""
    @Published var enteredAddress: String = ""
    
    // MARK: Methods
    /// Getting address from the location
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
                self.enteredAddress = ""
                completionHandler(address)
            } else {
                self.addressLocated = "No address found!"
                completionHandler(nil)
            }
        }
    }
    
    /// Searching address
    func searchAddress(completionHandler: @escaping ((Address?)->Void)) {
        if enteredAddress.isNotEmpty {
            findAddress { address in
                completionHandler(address)
            }
        } else {
            getAddress { address in
                completionHandler(address)
            }
        }
    }
    
    /// Centering map
    func centerMap(with address: Address) {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: address.latitude, longitude: address.longitude), latitudinalMeters: 750, longitudinalMeters: 750)
    }
    
    // MARK: Private
    // MARK: Method
    /// Finding address from the entered address
    private func findAddress(completionHandler: @escaping ((Address?)->Void)) {
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
