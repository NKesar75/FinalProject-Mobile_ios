//
//  WeatherIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 5/25/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation


class WeatherIC: WKInterfaceController {

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
    
    @IBOutlet var weatherTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchperviouscall(){
        if HomePageIC.requestinfo != nil{
            let weatherinfo = HomePageIC.requestinfo.split(separator: ",")
            
            weatherforcasts.append(weatherinfo(Location: weatherinfo[1] + ", " + weatherinfo[2],forcast: "Forcast: " + weatherinfo[3], image:  weatherinfo[4], rain: "Rain: " + weatherinfo[5] + "%", templow: "Low: "  + "°F", temphigh: "High: " + Servercalls.serverjson["results"][0]["temp_highf"].string! + "°F",humidty: "Humidity: " + String(Servercalls.serverjson["results"][0]["humidity"].double!), date: String(Servercalls.serverjson["results"][0]["month"].int!) + "/" + String(Servercalls.serverjson["results"][0]["day"].int!) + "/" + String(Servercalls.serverjson["results"][0]["year"].int!)))
        }
        
    }
    
    
    
    
    
    
    
    
    
}
