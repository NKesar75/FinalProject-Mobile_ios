//
//  Weather_IC.swift
//  Personal-Assistant-Watch Extension
//
//  Created by Raj  Chandan on 5/10/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import WatchKit

class Weather_IC: WKInterfaceController {

    @IBOutlet var WeatherTableView: WKInterfaceTable!
    
    struct weatherinfo : Decodable
    {
        var location : String
        var forcast : String
        var image : String
        var rain : String
        var templow : String
        var temphigh : String
        var date: String
    }
    
    let locationManager:CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String?
    var state: String?
    var voicecommand:String?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        apicall(city: city!, state: state!, voicecall: voicecommand!)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func apicall(city: String, state: String, voicecall: String) {
        print(voicecall)
        let jsonURL = "https://personalassistant-ec554.appspot.com/recognize/" + voicecall + "/" + state + "/" + city
        let url = URL(string: jsonURL)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do
            {
                 //self.weatherinfo = try JSONDecoder().decode([weatherinfo].self, from: data!)
            }
            catch
            {
                print("Error")
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
