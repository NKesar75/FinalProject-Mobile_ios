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
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        let button = RideRequestButton()
        button.frame.origin = CGPoint(x: 100, y: 30)
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        
        Mapkitview.setRegion(region, animated: true)
        Mapkitview.showsUserLocation = true
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
