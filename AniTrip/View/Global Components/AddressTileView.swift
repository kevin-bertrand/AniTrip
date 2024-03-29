//
//  AddressTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import MapKit
import SwiftUI

struct AddressTileView: View {    
    @State private var region: MKCoordinateRegion = LocationController.defaultMapPoint
    @State private var places: [MapPlace] = []
    
    let address: Address?
    var title: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title = title {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            
            if let address = address {
                HStack(alignment: .center) {
                    Map(coordinateRegion: $region, userTrackingMode: .none, annotationItems: places) { place in
                        MapMarker(coordinate: place.location, tint: .accentColor)
                    }
                    .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading) {
                        let link = "maps://?.saddr=&daddr=\(region.center.latitude),\(region.center.longitude)"
                        if let url = URL(string: link) {
                            Link(formatAddress(givenAddress: address), destination: url)
                        }
                    }
                    .font(.body.bold())
                    .padding(5)
                }
            } else {
                Text("No address")
                    .font(.body.bold())
                    .bold()
                    .font(.title2)
            }
        }
        .onAppear {
            if let address = address {
                self.places.append(MapPlace(lat: address.latitude, lon: address.longitude))
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: address.latitude,
                                                                                longitude: address.longitude),
                                                 latitudinalMeters: 750,
                                                 longitudinalMeters: 750)
            }
        }
    }
    
    private func formatAddress(givenAddress: Address) -> String {
        var address = "\(givenAddress.streetNumber), \(givenAddress.roadName)\n"
        
        if givenAddress.complement.isNotEmpty {
            address += "\(givenAddress.complement)\n"
        }

        address += "\(givenAddress.zipCode), \(givenAddress.city)\n"
        address += "\(givenAddress.country)\n"
        
        return address
    }
}

struct AddressTileView_Previews: PreviewProvider {
    static var previews: some View {
        AddressTileView(address: LocationController.emptyAddress)
    }
}
