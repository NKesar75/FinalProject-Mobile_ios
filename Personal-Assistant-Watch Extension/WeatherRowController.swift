//
//  WeatherRowController.swift
//  Personal-Assistant-Watch Extension
//
//  Created by Raj  Chandan on 5/10/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation

class WeatherRowController: NSObject
{

    @IBOutlet var weatherImg: WKInterfaceImage!
    @IBOutlet var weatherHigh: WKInterfaceLabel!
    @IBOutlet var weatherLow: WKInterfaceLabel!
    @IBOutlet var weatherForecast: WKInterfaceLabel!
    @IBOutlet var weatherRain: WKInterfaceLabel!
    @IBOutlet var weatherLocation: WKInterfaceLabel!
    @IBOutlet var weatherDate: WKInterfaceLabel!
    
}
