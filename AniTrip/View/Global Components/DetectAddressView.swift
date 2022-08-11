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
    @StateObject var locationManager = LocationController()
    @Binding var address: Address
    let name: String
    private let location = CLLocationManager()
    
    var body: some View {
        VStack {
            Text("\(name): \(locationManager.addressLocated)")
            
            ZStack(alignment: .bottom) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        Map(coordinateRegion: $locationManager.region)
                        Image(systemName: "mappin")
                            .resizable()
                            .frame(width: 19, height: 50)
                            .foregroundColor(.accentColor)
                            .padding(.bottom, 58)
                            .padding(.leading, 6)
                    }
                    
                    if location.authorizationStatus != .denied {
                        Button {
                            locationManager.requestLocation()
                        } label: {
                            Image(systemName: "location")
                                .padding()
                                .background(Color("LocationButton"))
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                Rectangle()
                    .foregroundColor(Color("TextFieldBackground"))
                    .frame(height: 170)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .shadow(radius: 2)
                VStack {
                    Text("Enter an address bellow or drag on the map.")
                        .foregroundColor(.gray)
                    TextField("Search", text: $locationManager.enteredAddress)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    HStack {
                        ButtonWithIcon(action: {
                            locationManager.searchAddress()
//                            locationManager.searchAddress { address in
//                                if let address = address {
//                                    self.address = address
//                                }
//                            }
                        }, icon: "magnifyingglass", title: "Search", height: 40)
                        .padding()
                        .frame(width: 300)
                    }
                }
            }
        }
        .onAppear {
            locationManager.centerMap(with: address)
        }
        .onDisappear {
            address = locationManager.address
        }
    }
}

struct DetectAddressView_Previews: PreviewProvider {
    static var previews: some View {
        DetectAddressView(address: .constant(LocationController.emptyAddress), name: "Starting address")
    }
}

