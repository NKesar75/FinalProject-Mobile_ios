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

class Map: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var Mapkitview: MKMapView!
    @IBOutlet weak var Sideview: UIView!
    @IBOutlet weak var Blur_View: UIVisualEffectView!
    @IBOutlet weak var View_constraint: NSLayoutConstraint!
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Blur_View.layer.cornerRadius = 15
        Sideview.layer.shadowColor = UIColor.black.cgColor
        Sideview.layer.shadowOpacity = 0.8
        Sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        View_constraint.constant = -175
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
          self.menu.isHidden = false
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func mapsbuttonpressed(_ sender: UIButton) {
        
        if View_constraint.constant > -175 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_constraint.constant = -175
                self.view.layoutIfNeeded()
                 self.menu.isHidden = false
            })
        }
    }
    
    @IBAction func menubuttonpressed(_ sender: UIButton) {
        if View_constraint.constant < 20 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_constraint.constant = 0
                self.view.layoutIfNeeded()
                 self.menu.isHidden = true
            })
        }
    }
    
    @IBAction func PanGestureREconizer(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if View_constraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_constraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                         self.menu.isHidden = true
                    })
                }
            }else{ //swipe left
                if View_constraint.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_constraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended{
            if View_constraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_constraint.constant = -175
                    self.view.layoutIfNeeded()
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_constraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
