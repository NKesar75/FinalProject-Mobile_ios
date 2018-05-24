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

class Map: UIViewController, CLLocationManagerDelegate {
    
    
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
        ridebutton.frame = CGRect(origin: CGPoint(x: view.bounds.maxX - 270, y: 30), size: CGSize(width: 240, height: 40))
        view.addSubview(ridebutton)
        // Do any additional setup after loading the view.
        
        let image = UIImage(named: "Location") as UIImage?
        let RCbutton   = UIButton(type: UIButtonType.custom) as UIButton
        RCbutton.frame = CGRect(origin: CGPoint(x:Mapkitview.bounds.maxX - 50, y: Mapkitview.bounds.maxY - 50), size: CGSize(width: 35, height: 35))
        RCbutton.setImage(image, for: .normal)
        RCbutton.backgroundColor = .clear
        RCbutton.addTarget(self, action: #selector(Map.centerMapOnUserButtonClicked), for:.touchUpInside)
        Mapkitview.addSubview(RCbutton)
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
                onloadcurrentlocation = false
        }
        
        
        
    }
    
    @IBAction func addpinforuber(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: self.Mapkitview)
        let locCoord = self.Mapkitview.convert(location, toCoordinateFrom: self.Mapkitview)
        let Destlat:Double = locCoord.latitude
        let Destlon:Double = locCoord.longitude
        //lblLocation.text = "\(lat), \(lng)"﻿
        
        let annonation = MKPointAnnotation()
        annonation.coordinate = locCoord
        annonation.title = "Destiation"
        annonation.subtitle = "Uber there"
    
        if Mapkitview.annotations.count > 1 {
            self.Mapkitview.removeAnnotations(Mapkitview.annotations)
        }

        self.Mapkitview.addAnnotation(annonation)
      

        let dropoffLocation = CLLocation(latitude: Destlat, longitude: Destlon)
        let builder = RideParametersBuilder()
        builder.dropoffLocation = dropoffLocation
        builder.dropoffNickname = "Destiation"
        ridebutton.rideParameters = builder.build()
        ridebutton.removeFromSuperview()
        view.addSubview(ridebutton)
    }
    
    
    
}
