//
//  WeatherInfoIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class WeatherInfoIC: WKInterfaceController {

    @IBOutlet var weatherInfoImg: WKInterfaceImage!
    @IBOutlet var weatherInfoHigh: WKInterfaceLabel!
    @IBOutlet var weatherInfoLow: WKInterfaceLabel!
    @IBOutlet var weatherInfoForecast: WKInterfaceLabel!
    @IBOutlet var weatherInfoRain: WKInterfaceLabel!
    @IBOutlet var weatherInfoLocation: WKInterfaceLabel!
    @IBOutlet var weatherInfoDate: WKInterfaceLabel!
    
    var sayDate: String = ""
    var sayForecast: String = ""
    var sayTemp_high: String = ""
    var sayTemp_Low: String = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let weatherInfoData = context as? weatherInfo
        {
            weatherInfoHigh.setText(weatherInfoData.temphigh)
            weatherInfoLow.setText(weatherInfoData.templow)
            weatherInfoRain.setText(weatherInfoData.rain)
            weatherInfoForecast.setText(weatherInfoData.forcast)
            weatherInfoLocation.setText(weatherInfoData.Location)
            weatherInfoDate.setText(weatherInfoData.date)
            let imgUrl = weatherInfoData.image
            if let url = URL(string: imgUrl)
            {
                do
                {
                    let data = try Data(contentsOf: url)
                    weatherInfoImg.setImageData(data)
                }
                catch let error
                {
                    print("Error : \(error.localizedDescription)")
                }
            }
            sayDate = weatherInfoData.date
            sayForecast = weatherInfoData.forcast
            sayTemp_high = weatherInfoData.temphigh
            sayTemp_Low = weatherInfoData.templow
        }
        
        let textTospeech = AVSpeechUtterance(string: "The weather for " + sayDate + " is " + sayForecast + " with temperatures from " + sayTemp_Low + " to " + sayTemp_high)
        textTospeech.voice = AVSpeechSynthesisVoice(language: "en-US")
        textTospeech.rate = 0.5
        
        let synthersizer = AVSpeechSynthesizer()
        synthersizer.speak(textTospeech)
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
