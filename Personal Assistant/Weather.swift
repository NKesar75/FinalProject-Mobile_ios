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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        weathertable.delegate = self
        weathertable.dataSource = self
        
        //locationManager.stopUpdatingLocation()
        self.FetchPreviousCall()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
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
    if Servercalls.serverjson["key"].string != nil && Servercalls.serverjson["key"].string == "weather" {
        weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][0]["condition"].string!,image:  Servercalls.serverjson["results"][0]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][0]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][0]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][0]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][0]["humidity"].double!), date: String(Servercalls.serverjson["results"][0]["month"].int!) + "/" + String(Servercalls.serverjson["results"][0]["day"].int!) + "/" + String(Servercalls.serverjson["results"][0]["year"].int!)))
        
         weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][1]["condition"].string!,image:  Servercalls.serverjson["results"][1]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][1]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][1]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][1]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][1]["humidity"].double!), date: String(Servercalls.serverjson["results"][1]["month"].int!) + "/" + String(Servercalls.serverjson["results"][1]["day"].int!) + "/" + String(Servercalls.serverjson["results"][1]["year"].int!)))
        
         weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][2]["condition"].string!,image:  Servercalls.serverjson["results"][2]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][2]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][2]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][2]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][2]["humidity"].double!), date: String(Servercalls.serverjson["results"][2]["month"].int!) + "/" + String(Servercalls.serverjson["results"][2]["day"].int!) + "/" + String(Servercalls.serverjson["results"][2]["year"].int!)))
        
          weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][3]["condition"].string!,image:  Servercalls.serverjson["results"][3]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][3]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][3]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][3]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][3]["humidity"].double!), date: String(Servercalls.serverjson["results"][3]["month"].int!) + "/" + String(Servercalls.serverjson["results"][3]["day"].int!) + "/" + String(Servercalls.serverjson["results"][3]["year"].int!)))
        
        weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][4]["condition"].string!,image:  Servercalls.serverjson["results"][4]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][4]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][4]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][4]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][4]["humidity"].double!), date: String(Servercalls.serverjson["results"][4]["month"].int!) + "/" + String(Servercalls.serverjson["results"][4]["day"].int!) + "/" + String(Servercalls.serverjson["results"][4]["year"].int!)))
        
          weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][5]["condition"].string!,image:  Servercalls.serverjson["results"][5]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][5]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][5]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][5]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][5]["humidity"].double!), date: String(Servercalls.serverjson["results"][5]["month"].int!)  + "/" + String(Servercalls.serverjson["results"][5]["day"].int!) + "/" + String(Servercalls.serverjson["results"][5]["year"].int!)))
        
        weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][6]["condition"].string!,image:  Servercalls.serverjson["results"][6]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][6]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][6]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][6]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][6]["humidity"].double!), date: String(Servercalls.serverjson["results"][6]["month"].int!) + "/" + String(Servercalls.serverjson["results"][6]["day"].int!) + "/" + String(Servercalls.serverjson["results"][6]["year"].int!)))
        }
    }
    
   func FetchJSON() {
        let server = Servercalls()
        server.apicall(city: city!, state: state!, voicecall: self.stringtoserver!)
        print(Servercalls.serverjson)
        if Servercalls.serverjson["key"].string != nil {
            switch (Servercalls.serverjson["key"].string!){
            case "weather":
                weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][0]["condition"].string!,image:  Servercalls.serverjson["results"][0]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][0]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][0]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][0]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][0]["humidity"].double!), date: String(Servercalls.serverjson["results"][0]["month"].int!) + "/" + String(Servercalls.serverjson["results"][0]["day"].int!) + "/" + String(Servercalls.serverjson["results"][0]["year"].int!)))
                
                weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][1]["condition"].string!,image:  Servercalls.serverjson["results"][1]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][1]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][1]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][1]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][1]["humidity"].double!), date: String(Servercalls.serverjson["results"][1]["month"].int!) + "/" + String(Servercalls.serverjson["results"][1]["day"].int!) + "/" + String(Servercalls.serverjson["results"][1]["year"].int!)))
                
                weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][2]["condition"].string!,image:  Servercalls.serverjson["results"][2]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][2]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][2]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][2]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][2]["humidity"].double!), date: String(Servercalls.serverjson["results"][2]["month"].int!) + "/" + String(Servercalls.serverjson["results"][2]["day"].int!) + "/" + String(Servercalls.serverjson["results"][2]["year"].int!)))
                
                weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][3]["condition"].string!,image:  Servercalls.serverjson["results"][3]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][3]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][3]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][3]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][3]["humidity"].double!), date: String(Servercalls.serverjson["results"][3]["month"].int!) + "/" + String(Servercalls.serverjson["results"][3]["day"].int!) + "/" + String(Servercalls.serverjson["results"][3]["year"].int!)))
                
                weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][4]["condition"].string!,image:  Servercalls.serverjson["results"][4]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][4]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][4]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][4]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][4]["humidity"].double!), date: String(Servercalls.serverjson["results"][4]["month"].int!) + "/" + String(Servercalls.serverjson["results"][4]["day"].int!) + "/" + String(Servercalls.serverjson["results"][4]["year"].int!)))
                
                weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][5]["condition"].string!,image:  Servercalls.serverjson["results"][5]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][5]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][5]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][5]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][5]["humidity"].double!), date: String(Servercalls.serverjson["results"][5]["month"].int!)  + "/" + String(Servercalls.serverjson["results"][5]["day"].int!) + "/" + String(Servercalls.serverjson["results"][5]["year"].int!)))
                
                weatherforcasts.append(weatherinfo(Location: Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!,forcast: "Forcast: " + Servercalls.serverjson["results"][6]["condition"].string!,image:  Servercalls.serverjson["results"][6]["url"].string!,rain: "Rain: " + String(Servercalls.serverjson["results"][6]["precip"].double!) + "%", templow: "Low: " + Servercalls.serverjson["results"][6]["temp_lowf"].string! + "°F", temphigh: "High: " + Servercalls.serverjson["results"][6]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][6]["humidity"].double!), date: String(Servercalls.serverjson["results"][6]["month"].int!) + "/" + String(Servercalls.serverjson["results"][6]["day"].int!) + "/" + String(Servercalls.serverjson["results"][6]["year"].int!)))
                
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
    
}
