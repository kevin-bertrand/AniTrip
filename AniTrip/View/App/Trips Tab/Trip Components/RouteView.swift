//
//  RouteView.swift
//  AniTrip
//
//  Created by Kevin Bertrand on 20/07/2022.
//

import MapKit
import SwiftUI
import UIKit

struct RouteView: View {
    @State private var showDirections = false
    let startPoint: CLLocationCoordinate2D
    let endPoint: CLLocationCoordinate2D
    
    var body: some View {
        VStack {
            MapView(startPoint: startPoint, endPoint: endPoint)
        }
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView(startPoint: CLLocationCoordinate2D(latitude: 40.71, longitude: -74), endPoint: CLLocationCoordinate2D(latitude: 42.36, longitude: -71.05))
    }
}

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
    let startPoint: CLLocationCoordinate2D
    let endPoint: CLLocationCoordinate2D
        
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = LocationController.defaultMapPoint
        mapView.setRegion(region, animated: true)
        
        let p1 = MKPlacemark(coordinate: startPoint)
        
        // Boston
        let p2 = MKPlacemark(coordinate: endPoint)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addAnnotations([p1, p2])
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
                animated: true)
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(Color.accentColor)
            renderer.lineWidth = 5
            return renderer
        }
    }
}
