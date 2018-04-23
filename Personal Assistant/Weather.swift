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
        
    }
    
    struct Weather: Decodable {
        let key: String
        let tempf: Double
        let tempc: Double
        let city: String
        let state: String
        let rain: Double
        let forcast: String
        let humidity: String
        let forcastImage: String
        
        // swift 4.0
        private enum CodingKeys: String, CodingKey {
            case key = "key"
            case tempf = "tempf"
            case tempc = "tempc"
            case city = "city"
            case state = "state"
            case rain = "precip"
            case forcast = "condition"
            case humidity = "humidity"
            case forcastImage = "url"
        }
    }
    
    
    fileprivate func FetchJSON() {
        var temp = self.state! + "/" + self.city!
        let urlString = "https://personalassistant-ec554.appspot.com/recognize/" + HomePage.stringtoserver! + "/" + temp
        print(HomePage.stringtoserver!)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                
                guard let data = data else { return }
                do {
                    // Swift 4.1
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let Cweather = try JSONDecoder().decode(Weather.self, from: data)
                    self.CurrentWeatherDisplay.text = String(Cweather.tempf) + "°F"
                    self.CurrentCityDisplay.text = Cweather.city + ", " + Cweather.state
                    self.CurrentRainDisplay.text = "Rain: " + String(Cweather.rain) + "%"
                    self.CurrentForcastDisplay.text = "Forcast: " + Cweather.forcast
                    self.CurrentHumdidityDisplay.text = "Humidity: " + Cweather.humidity
                    let imageUrl:URL = URL(string: Cweather.forcastImage)!
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                    self.currentforcastimagedisplay.image = UIImage(data: imageData as Data)
                    self.currentforcastimagedisplay.contentMode = UIViewContentMode.scaleAspectFit
                      
                    
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
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
                 self.FetchJSON()
                
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
