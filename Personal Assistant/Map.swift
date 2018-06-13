//
//  Map.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/16/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import UberRides

class Map: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    let geocoder = CLGeocoder()
    @IBOutlet weak var addresstext: UITextField!
    @IBOutlet weak var Mapkitview: MKMapView!
    @IBOutlet weak var homebutton: UIButton!
    let ridebutton = RideRequestButton()
    let locationManager:CLLocationManager = CLLocationManager()
    var onloadcurrentlocation: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        onloadcurrentlocation = true
        Mapkitview.showsUserLocation = true
        ridebutton.frame = CGRect(origin: CGPoint(x: view.bounds.maxX - 270, y: 30), size: CGSize(width: 240, height: 30))
        view.addSubview(ridebutton)
        // Do any additional setup after loading the view.
        Mapkitview.delegate = self
        
        let image = UIImage(named: "Location") as UIImage?
        let RCbutton = UIButton(type: UIButtonType.custom) as UIButton
        RCbutton.frame = CGRect(origin: CGPoint(x:Mapkitview.bounds.maxX, y: Mapkitview.bounds.maxY), size: CGSize(width: 30, height: 30))
        RCbutton.setImage(image, for: .normal)
        RCbutton.backgroundColor = .clear
        RCbutton.addTarget(self, action: #selector(Map.centerMapOnUserButtonClicked), for:.touchUpInside)
        Mapkitview.addSubview(RCbutton)
        
    }
    
    
    
    
    
    @IBAction func Search(_ sender: UIButton) {
        
        if addresstext.text != nil && addresstext.text != "" && addresstext.text != " "{
            
            let localSearchRequest = MKLocalSearchRequest()
            localSearchRequest.naturalLanguageQuery = addresstext.text
            let region = MKCoordinateRegion(center: Mapkitview.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            localSearchRequest.region = region
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.start { (response, _) in
                guard let response = response else { return }
                guard let firstMapItem = response.mapItems.first else { return }
                
                let userlocationpin = MKPlacemark(coordinate: self.Mapkitview.userLocation.coordinate)
                
                
                let directionrequest = MKDirectionsRequest()
                directionrequest.source = MKMapItem(placemark: userlocationpin)
                directionrequest.destination = firstMapItem
                directionrequest.transportType = .automobile
                
                let directions = MKDirections(request: directionrequest)
                directions.calculate { (reposnse, error) in
                    guard let directionsresponse = reposnse else
                    {
                        if let error = error{
                            print("ERROR ERROR ERROR")
                            print(error.localizedDescription)
                        }
                        return
                    }
                    
                    let route = directionsresponse.routes[0]
                    if self.Mapkitview.overlays.count > 0 {
                        self.Mapkitview.removeOverlays(self.Mapkitview.overlays)
                    }
                    self.Mapkitview.add(route.polyline, level: .aboveRoads)
                    
                    let annonation = MKPointAnnotation()
                    annonation.coordinate = firstMapItem.placemark.coordinate
                    annonation.title = "Destiation"
                    annonation.subtitle = "Uber there"
                    
                    if self.Mapkitview.annotations.count > 1 {
                        self.Mapkitview.removeAnnotations(self.Mapkitview.annotations)
                    }
                    
                    self.Mapkitview.addAnnotation(annonation)
                    let dropoffLocation = CLLocation(latitude: firstMapItem.placemark.coordinate.latitude, longitude: firstMapItem.placemark.coordinate.longitude)
                    let builder = RideParametersBuilder()
                    builder.dropoffLocation = dropoffLocation
                    builder.dropoffNickname = "Destiation"
                    self.ridebutton.rideParameters = builder.build()
                    self.ridebutton.removeFromSuperview()
                    self.view.addSubview(self.ridebutton)
                }
            }
            
        }
    }
    
    
    @objc func centerMapOnUserButtonClicked() {
        let region = MKCoordinateRegion(center: Mapkitview.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) )
        Mapkitview.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        if (onloadcurrentlocation){
            let center = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: center, span: span)
            Mapkitview.setRegion(region, animated: true)
            Mapkitview.userTrackingMode = .followWithHeading
            onloadcurrentlocation = false
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    @IBAction func addpinforuber(_ sender: UILongPressGestureRecognizer) {
        
        
        let location = sender.location(in: self.Mapkitview)
        let locCoord = self.Mapkitview.convert(location, toCoordinateFrom: self.Mapkitview)
        let Destlat:Double = locCoord.latitude
        let Destlon:Double = locCoord.longitude
        
        let annonation = MKPointAnnotation()
        annonation.coordinate = locCoord
        annonation.title = "Destiation"
        annonation.subtitle = "Uber there"
        
        if Mapkitview.annotations.count > 1 {
            self.Mapkitview.removeAnnotations(Mapkitview.annotations)
            self.Mapkitview.removeOverlays(Mapkitview.overlays)
        }
        
        self.Mapkitview.addAnnotation(annonation)
        let dropoffLocation = CLLocation(latitude: Destlat, longitude: Destlon)
        let builder = RideParametersBuilder()
        builder.dropoffLocation = dropoffLocation
        builder.dropoffNickname = "Destiation"
        ridebutton.rideParameters = builder.build()
        ridebutton.removeFromSuperview()
        view.addSubview(ridebutton)
        
        let userlocationpin = MKPlacemark(coordinate: Mapkitview.userLocation.coordinate)
        let destiationlocationpin = MKPlacemark(coordinate: dropoffLocation.coordinate)
        
        let directionrequest = MKDirectionsRequest()
        directionrequest.source = MKMapItem(placemark: userlocationpin)
        directionrequest.destination = MKMapItem(placemark: destiationlocationpin)
        directionrequest.transportType = .automobile
        
        let directions = MKDirections(request: directionrequest)
        directions.calculate { (reposnse, error) in
            guard let directionsresponse = reposnse else
            {
                if let error = error{
                    print("ERROR ERROR ERROR")
                    print(error.localizedDescription)
                }
                return
            }
            
            let route = directionsresponse.routes[0]
            self.Mapkitview.add(route.polyline, level: .aboveRoads)
            
        }
    }
}
