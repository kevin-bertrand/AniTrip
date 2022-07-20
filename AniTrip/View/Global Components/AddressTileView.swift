//
//  AddressTileView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 18/07/2022.
//

import MapKit
import SwiftUI

struct AddressTileView: View {
    @StateObject private var mapController: MapController = MapController()
    
    @State private var region: MKCoordinateRegion = MapController.defaultMapPoint
    @State private var places: [MapPlace] = []
    let address: Address?
    var title: String? = nil
    
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
                        if let url = URL(string: "maps://?.saddr=&daddr=\(region.center.latitude),\(region.center.longitude)") {
                            
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
            mapController.getCoordinatesForAddress(address) { place, region in
                if let place = place {
                    self.places.append(MapPlace(location: place))
                }
                
                if let region = region {
                    self.region = region
                }
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
        AddressTileView(address: Address(roadName: "Des developpers", streetNumber: "7a", complement: "3rd floor", zipCode: "7500", city: "Paris", country: "France", latitude: 0.0, longitude: 0.0))
    }
}
