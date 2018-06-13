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
import SwiftyJSON

class Weather: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var weathertable: UITableView!
    @IBOutlet weak var Searchweathertext: UITextField!
    
    var serverjson = JSON()
    
    struct weatherinfo{
        var Location : String
        var forcast : String
        var image : String
        var rain : String
        var templow : String
        var temphigh : String
        var humidty : String
        var date: String
    }
    
    var weatherforcasts:[weatherinfo] = []
    
    let locationManager:CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String?
    var state: String?
    var stringtoserver:String?
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        weathertable.delegate = self
        weathertable.dataSource = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Weather.dismissKeyboard))
        
        //comment the line below if you want the tap to interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.FetchPreviousCall()
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func SearchForWeather(_ sender: UIButton) {
        if Searchweathertext.text != "" && Searchweathertext.text != " "{
            activityindactor.center = self.view.center
            activityindactor.hidesWhenStopped = true
            activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            view.addSubview(activityindactor)
            activityindactor.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            var servermetod = "whats the weather in " + Searchweathertext.text!.lowercased()
            servermetod = servermetod.trimmingCharacters(in: .whitespacesAndNewlines)
            servermetod = servermetod.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            let urlString = "https://personalassistant-ec554.appspot.com/recognize/" + servermetod + "/" + self.state! + "/" + self.city!
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, reponse, err) in
                guard let data = data else { return }
                do {
                    
                    self.serverjson = try JSON(data: data)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                
                }.resume()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
                if self.serverjson["key"].string != nil && self.serverjson["key"] == "weather" {
                    
                    self.FetchPreviousCall()
                    self.weathertable.reloadData()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityindactor.removeFromSuperview()
                    
                    
                }else{
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityindactor.removeFromSuperview()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherforcasts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wcell = weathertable.dequeueReusableCell(withIdentifier: "weathercustomcell") as! WeatherTableViewCell
        
        wcell.weatherforcast.text = weatherforcasts[indexPath.row].forcast
        wcell.weatherrain.text =  weatherforcasts[indexPath.row].rain
        wcell.weatherhumidty.text =  weatherforcasts[indexPath.row].humidty
        wcell.weathertemplow.text =  weatherforcasts[indexPath.row].templow
        wcell.weathertemphigh.text =  weatherforcasts[indexPath.row].temphigh
        wcell.weatherlocation.text =  weatherforcasts[indexPath.row].Location
        wcell.Weatherdayoftheyear.text = weatherforcasts[indexPath.row].date
        let imageUrl:URL = URL(string: weatherforcasts[indexPath.row].image)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        wcell.weatherimage.image = UIImage(data: imageData as Data)
        wcell.weatherimage.contentMode = UIViewContentMode.scaleAspectFit
        
        return wcell
    }
    
    func FetchPreviousCall(){
        if self.serverjson["key"].string != nil && self.serverjson["key"].string == "weather" {
            weatherforcasts.removeAll()
            
            var index:Int = 0
            while true {
                
                if  self.serverjson["city"].string != nil && self.serverjson["state"].string != nil && self.serverjson["results"][index]["condition"].string != nil && self.serverjson["results"][index]["url"].string != nil && self.serverjson["results"][index]["precip"].double != nil && self.serverjson["results"][index]["temp_lowf"].string != nil && self.serverjson["results"][index]["temp_highf"].string != nil && self.serverjson["results"][index]["humidity"].double != nil && self.serverjson["results"][index]["month"].int != nil &&  self.serverjson["results"][index]["day"].int != nil && self.serverjson["results"][index]["year"].int != nil {
                    
                    weatherforcasts.append(weatherinfo(Location: self.serverjson["city"].string! + ", " + self.serverjson["state"].string!,forcast: "Forcast: " + self.serverjson["results"][index]["condition"].string!,image:  self.serverjson["results"][index]["url"].string!,rain: "Rain: " + String(self.serverjson["results"][index]["precip"].double!) + "%", templow: "Low: " + self.serverjson["results"][index]["temp_lowf"].string! + "°F", temphigh: "High: " + self.serverjson["results"][index]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(self.serverjson["results"][index]["humidity"].double!), date: String(self.serverjson["results"][index]["month"].int!) + "/" + String(self.serverjson["results"][index]["day"].int!) + "/" + String(self.serverjson["results"][index]["year"].int!)))
                }else{
                    break
                }
                index += 1
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                self.placemark = placemark.last
            }
            if let _:CLLocation = location {
                if let placemark = self.placemark {
                    if let city = placemark.locality, !city.isEmpty {
                        self.city = city
                    }
                    if let state = placemark.administrativeArea, !state.isEmpty {
                        
                        self.state = state
                    }
                }
                if self.city != nil && self.state != nil {
                    self.city = self.city!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                }
            }
        })
    }
    
}
