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

    
    
    
    
    
    //merge check
    //lets see
    //cassac
    //cs
    
    //cssc
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchperviouscall(){
        if HomePageIC.requestinfo != "" && HomePageIC.requestinfo != nil{
            let weatherinfoarray = HomePageIC.requestinfo.split(separator: ",")
            //0 key //1 city //2 state //3 condition //4 url //5 rain //6 temp low //7 temp high //8 month/date/year //9 repeat condition
            
            weatherforcasts.append(weatherinfo(Location: weatherinfoarray[1] + ", " + weatherinfoarray[2],forcast: "Forcast: " + weatherinfoarray[3], image:  String(weatherinfoarray[4]), rain: "Rain: " + weatherinfoarray[5] + "%", templow: "Low: " + weatherinfoarray[6] + "°F", temphigh: "High: " + weatherinfoarray[7] + "°F", date: String(weatherinfoarray[8])))
            
            weatherforcasts.append(weatherinfo(Location: weatherinfoarray[1] + ", " + weatherinfoarray[2],forcast: "Forcast: " + weatherinfoarray[9], image:  String(weatherinfoarray[10]), rain: "Rain: " + weatherinfoarray[11] + "%", templow: "Low: " + weatherinfoarray[12] + "°F", temphigh: "High: " + weatherinfoarray[13] + "°F", date: String(weatherinfoarray[14])))
            
            weatherforcasts.append(weatherinfo(Location: weatherinfoarray[1] + ", " + weatherinfoarray[2],forcast: "Forcast: " + weatherinfoarray[15], image:  String(weatherinfoarray[16]), rain: "Rain: " + weatherinfoarray[17] + "%", templow: "Low: " + weatherinfoarray[18] + "°F", temphigh: "High: " + weatherinfoarray[19] + "°F", date: String(weatherinfoarray[20])))
            
            weatherforcasts.append(weatherinfo(Location: weatherinfoarray[1] + ", " + weatherinfoarray[2],forcast: "Forcast: " + weatherinfoarray[21], image:  String(weatherinfoarray[22]), rain: "Rain: " + weatherinfoarray[23] + "%", templow: "Low: " + weatherinfoarray[24] + "°F", temphigh: "High: " + weatherinfoarray[25] + "°F", date: String(weatherinfoarray[26])))
            
            weatherforcasts.append(weatherinfo(Location: weatherinfoarray[1] + ", " + weatherinfoarray[2],forcast: "Forcast: " + weatherinfoarray[27], image:  String(weatherinfoarray[28]), rain: "Rain: " + weatherinfoarray[29] + "%", templow: "Low: " + weatherinfoarray[30] + "°F", temphigh: "High: " + weatherinfoarray[31] + "°F", date: String(weatherinfoarray[32])))
            
            weatherforcasts.append(weatherinfo(Location: weatherinfoarray[1] + ", " + weatherinfoarray[2],forcast: "Forcast: " + weatherinfoarray[33], image:  String(weatherinfoarray[34]), rain: "Rain: " + weatherinfoarray[35] + "%", templow: "Low: " + weatherinfoarray[36] + "°F", temphigh: "High: " + weatherinfoarray[37] + "°F", date: String(weatherinfoarray[38])))
            
            weatherforcasts.append(weatherinfo(Location: weatherinfoarray[1] + ", " + weatherinfoarray[2],forcast: "Forcast: " + weatherinfoarray[39], image:  String(weatherinfoarray[40]), rain: "Rain: " + weatherinfoarray[41] + "%", templow: "Low: " + weatherinfoarray[42] + "°F", temphigh: "High: " + weatherinfoarray[43] + "°F", date: String(weatherinfoarray[44])))
        }
        
    }
    
    
    
    
    
    
    
    
    
}
