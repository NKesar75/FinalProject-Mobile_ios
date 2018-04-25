//
//  Weather.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/11/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Weather: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var Sideview: UIView!
    @IBOutlet weak var Blur_View: UIVisualEffectView!
    @IBOutlet weak var View_Constraint: NSLayoutConstraint!
    @IBOutlet weak var menu: UIButton!
    let locationManager:CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String?
    var state: String?
    var stringtoserver:String?
    @IBOutlet weak var CurrentWeatherDisplay: UILabel!
    @IBOutlet weak var CurrentCityDisplay: UILabel!
    @IBOutlet weak var CurrentRainDisplay: UILabel!
    @IBOutlet weak var CurrentForcastDisplay: UILabel!
    @IBOutlet weak var CurrentHumdidityDisplay: UILabel!
    @IBOutlet weak var currentforcastimagedisplay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Blur_View.layer.cornerRadius = 15
        Sideview.layer.shadowColor = UIColor.black.cgColor
        Sideview.layer.shadowOpacity = 0.8
        Sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        View_Constraint.constant = -175
        self.menu.isHidden = false
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        //locationManager.stopUpdatingLocation()
        self.FetchPreviousCall()
        
    }
    
    func FetchPreviousCall(){
    if Servercalls.serverjson["key"].string != nil {
        self.CurrentCityDisplay.text = Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!
        self.CurrentHumdidityDisplay.text = "Humidity: " + Servercalls.serverjson["humidity"].string!
        self.CurrentRainDisplay.text = "Rain: " + String(Servercalls.serverjson["precip"].double!) + "%"
        self.CurrentForcastDisplay.text = "Forcast: " + Servercalls.serverjson["condition"].string!
        self.CurrentWeatherDisplay.text = String(Servercalls.serverjson["tempf"].double!) + "°F"
        let imageUrl:URL = URL(string: Servercalls.serverjson["url"].string!)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        self.currentforcastimagedisplay.image = UIImage(data: imageData as Data)
        self.currentforcastimagedisplay.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
    
   func FetchJSON() {
        let server = Servercalls()
        server.apicall(city: city!, state: state!, voicecall: self.stringtoserver!)
        print(Servercalls.serverjson)
        if Servercalls.serverjson["key"].string != nil {
            switch (Servercalls.serverjson["key"].string!){
            case "weather":
                self.CurrentCityDisplay.text = Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!
                self.CurrentHumdidityDisplay.text = "Humidity: " + Servercalls.serverjson["humidity"].string!
                self.CurrentRainDisplay.text = "Rain: " + String(Servercalls.serverjson["precip"].double!) + "%"
                self.CurrentForcastDisplay.text = "Forcast: " + Servercalls.serverjson["condition"].string!
                self.CurrentWeatherDisplay.text = String(Servercalls.serverjson["tempf"].double!) + "°F"
                let imageUrl:URL = URL(string: Servercalls.serverjson["url"].string!)!
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                self.currentforcastimagedisplay.image = UIImage(data: imageData as Data)
                self.currentforcastimagedisplay.contentMode = UIViewContentMode.scaleAspectFit
            case "youtube":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Youtube_ID") as! Youtube
                self.present(vc, animated: true, completion: nil)
            case "google":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Search_ID") as! Search
                self.present(vc, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locations[0]
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            // always good to check if no error
            // also we have to unwrap the placemark because it's optional
            // I have done all in a single if but you check them separately
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                self.placemark = placemark.last
            }
            // a new function where you start to parse placemarks to get the information you need
            // here we check if location manager is not nil using a _ wild card
            if let _:CLLocation = location {
                // unwrap the placemark
                if let placemark = self.placemark {
                    // wow now you can get the city name. remember that apple refers to city name as locality not city
                    // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
                    if let city = placemark.locality, !city.isEmpty {
                        // here you have the city name
                        // assign city name to our iVar
                        self.city = city
                    }
                    // the same story optionalllls also they are not empty
                    if let state = placemark.administrativeArea, !state.isEmpty {
                        
                        self.state = state
                    }
                    
                }
                
                self.city = self.city!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                print(self.city)
                print(self.state)
                
            } else {
                // add some more check's if for some reason location manager is nil
            }
        })
    }
    @IBAction func weatherpressedonweather(_ sender: UIButton) {
        if View_Constraint.constant > -175 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_Constraint.constant = -175
                self.view.layoutIfNeeded()
                self.menu.isHidden = false
            })
        }
    }
    @IBAction func menubuttonpressed(_ sender: UIButton) {
        if View_Constraint.constant < 20 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_Constraint.constant = 0
                self.view.layoutIfNeeded()
                self.menu.isHidden = true
            })
        }
    }
    @IBAction func Pan_guuesture(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if View_Constraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_Constraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        self.menu.isHidden = true
                    })
                }
            }else{ //swipe left
                if View_Constraint.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_Constraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended{
            if View_Constraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_Constraint.constant = -175
                    self.view.layoutIfNeeded()
                    self.menu.isHidden = false
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_Constraint.constant = 0
                    self.view.layoutIfNeeded()
                })
    }
        }
    }
    
}
