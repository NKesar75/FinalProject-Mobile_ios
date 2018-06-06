//
//  weatherInfo.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import Foundation
import WatchKit

class weatherInfo
{
    var Location : String
    var forcast : String
    var image : String
    var rain : String
    var templow : String
    var temphigh : String
    var date: String
    
    init(location: String, forecast: String, image : String, rain : String, templow : String, temphigh : String, date : String)
    {
        self.Location = location
        self.forcast = forecast
        self.image = image
        self.rain = rain
        self.templow = templow
        self.temphigh = temphigh
        self.date = date
    }
}
