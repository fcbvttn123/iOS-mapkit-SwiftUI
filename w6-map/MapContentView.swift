//
//  MapContentView.swift
//  w6-map
//
//  Created by Default User on 10/9/24.
//

import SwiftUI
import MapKit

struct Location : Identifiable {
    let id = UUID()
    let name : String
    let coordinate : CLLocationCoordinate2D
}

struct RouteSteps : Identifiable {
    let id = UUID()
    let step : String
}

struct MapContentView: View {
    let home = CLLocationCoordinate2D(latitude: 40.7484400, longitude: -73.985664)
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7484400, longitude: -73.985664),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State var annotations = [
        Location(
            name: "Empire State Building",
            coordinate: CLLocationCoordinate2D(latitude: 40.7484400, longitude: -73.985664)
        )
    ]
    @State var tbLocationEntered : String = ""
    @State var routeSteps : [RouteSteps] = [RouteSteps(step: "Enter destination to see the steps")]
    var body: some View {
        VStack {
            HStack {
                TextField("Where do you want to go?", text: $tbLocationEntered)
                Button(action: {
                    findNewLocation()
                }) {
                    Text("Go")
                }
            }.padding(50)
            Map(coordinateRegion: $region, annotationItems: annotations) { item in
                MapPin(coordinate: item.coordinate)
            }.frame(width: 400, height: 300)
            List(routeSteps) { r in
                Text(r.step)
            }
        }
    }
    func findNewLocation() {
        let locEnteredText = tbLocationEntered
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locEnteredText, completionHandler: { (placemarks, error) in
            if(error != nil) {
                print("Error")
            }
            if let placemark = placemarks?.first {
                let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
                annotations.append(Location(name: placemark.name!, coordinate: coordinates))
                let request = MKDirections.Request()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.home))
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
                request.requestsAlternateRoutes = false
                request.transportType = .automobile
                let direction = MKDirections(request: request)
                direction.calculate(completionHandler: { response, error in
                    routeSteps = []
                    for route in (response?.routes)! {
                        for step in route.steps {
                            routeSteps.append(RouteSteps(step: step.instructions))
                        }
                    }
                })
            }
        })
    }
}

#Preview {
    MapContentView()
}
