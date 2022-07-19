//
//  DetectAddressView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 19/07/2022.
//

import CoreLocation
import CoreLocationUI
import MapKit
import SwiftUI

struct DetectAddressView: View {
    @StateObject var locationManager = LocationManager()
    @Binding var address: Address
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    address = MapController.emptyAddress
                    showSheet = false
                } label: {
                    Label("Cancel", systemImage: "x.circle")
                }

                Spacer()
                
                Button {
                    showSheet = false
                } label: {
                    Label("Validate", systemImage: "v.circle")
                }
            }.padding()
            
            Text("Address: \(locationManager.addressLocated)")
            
            ZStack(alignment: .bottom) {
                ZStack {
                    ZStack(alignment: .topTrailing) {
                        Map(coordinateRegion: $locationManager.region, interactionModes: .all, showsUserLocation: true)
                        
                        Button {
                            locationManager.requestLocation()
                        } label: {
                            Image(systemName: "location")
                                .frame(width: 40, height: 40)
                                .background(Color("ButtonIconBackground"))
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                    Image(systemName: "mappin")
                        .resizable()
                        .frame(width: 20, height: 50)
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 58)
                        .padding(.leading, 6)
                }
                ButtonWithIcon(action: {
                    locationManager.getAddress { address in
                        if let address = address {
                            self.address = address
                        }
                    }
                }, title: "Get address of point")
                .padding()
            }
        }
    }
}

struct DetectAddressView_Previews: PreviewProvider {
    static var previews: some View {
        DetectAddressView(address: .constant(MapController.emptyAddress), showSheet: .constant(true))
    }
}

