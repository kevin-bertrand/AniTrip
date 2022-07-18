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
    
    var body: some View {
        Group {
            if let address = address {
                HStack {
                    Map(coordinateRegion: $region, annotationItems: places) { place in
                        MapMarker(coordinate: place.location, tint: .accentColor)
                    }
                    .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading) {
                        if let url = URL(string: "maps://?.saddr=&daddr=\(region.center.latitude),\(region.center.longitude)") {
                            
                            let address = """
                            \(address.streetNumber), \(address.roadType) \(address.roadName)
                            \(address.complement)
                            \(address.zipCode), \(address.city)
                            \(address.country)
                            """
                            
                            Link(address, destination: url)
                        }
                    }
                    .bold()
                    .padding(5)
                }
            } else {
                Text("No address")
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
}

struct AddressTileView_Previews: PreviewProvider {
    static var previews: some View {
        AddressTileView(address: Address(roadName: "Des developpers", roadType: "Place", streetNumber: "7a", complement: "3rd floor", zipCode: "7500", city: "Paris", country: "France"))
    }
}
