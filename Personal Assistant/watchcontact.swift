//
//  watchcontact.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class watchcontact: NSObject, NSCoding {
    var Location : String?
    var forcast : String?
    var image : String?
    var rain : String?
    var templow : String?
    var temphigh : String?
    var humidty : String?
    var date: String?
    
    func initwithdataweather(Location : String, forcast : String, image : String, rain : String, templow : String, temphigh : String, humidty : String, date: String){
        
      self.Location = Location
      self.forcast = forcast
      self.image = image
      self.rain = rain
      self.templow = templow
      self.temphigh = temphigh
      self.humidty = humidty
      self.date = date
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let Location = aDecoder.decodeObject(forKey: "Location") as? String,
        let forcast =  aDecoder.decodeObject(forKey: "forcast") as? String,
        let image = aDecoder.decodeObject(forKey: "image") as? String,
        let rain = aDecoder.decodeObject(forKey: "rain") as? String,
        let templow = aDecoder.decodeObject(forKey: "templow") as? String,
        let temphigh = aDecoder.decodeObject(forKey: "temphigh") as? String,
        let humidty = aDecoder.decodeObject(forKey: "humidty") as? String,
        let date = aDecoder.decodeObject(forKey: "date") as? String
            else{
                return nil
        }
        self.init()
        self.initwithdataweather(Location: Location, forcast: forcast, image: image, rain: rain, templow: templow, temphigh: temphigh, humidty: humidty, date: date)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.Location, forKey: "Location")
        aCoder.encode(self.forcast, forKey: "forcast")
        aCoder.encode(self.image, forKey: "image")
        aCoder.encode(self.rain, forKey: "rain")
        aCoder.encode(self.templow, forKey: "templow")
        aCoder.encode(self.temphigh, forKey: "temphigh")
        aCoder.encode(self.humidty, forKey: "humidty")
        aCoder.encode(self.date, forKey: "date")
    }
    
}
