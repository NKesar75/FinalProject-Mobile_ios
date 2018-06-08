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
    
    var weatherforcasts: [weatherInfo] = []
    
    @IBOutlet var weatherTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
       
        loadDataintoTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func loadDataintoTable()
    {
         fetchperviouscall()
        print(weatherforcasts.count)
        weatherTable.setNumberOfRows(weatherforcasts.count, withRowType: "WeatherRowController")

        for (index, _) in weatherforcasts.enumerated()
        {
            if let rowController = weatherTable.rowController(at: index) as? WeatherRowController
            {
                rowController.weatherHigh.setText(weatherforcasts[index].temphigh)
                rowController.weatherLow.setText(weatherforcasts[index].templow)
                rowController.weatherDate.setText(weatherforcasts[index].date)
                let imgUrl = weatherforcasts[index].image
                if let url = URL(string: imgUrl)
                {
                    do
                    {
                        let data = try Data(contentsOf: url)
                        rowController.weatherImage.setImageData(data)
                    }
                    catch let error
                    {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int)
    {
        pushController(withName: "WeatherInfoIdentifier", context: weatherforcasts[rowIndex])
    }
    
    
    func fetchperviouscall(){
        if HomePageIC.requestinfo != ""
        {
            let weatherinfoarray = HomePageIC.requestinfo.split(separator: "\u{1D6FF}")
            //0 key //1 city //2 state //3 condition //4 url //5 rain //6 temp low //7 temp high //8 month/date/year //9 repeat condition
            //print(weatherinfoarray)
            
            let one = weatherInfo(location: weatherinfoarray[1] + ", " + weatherinfoarray[2], forecast: "Forecast: " + weatherinfoarray[3], image: String(weatherinfoarray[4]), rain: "Rain: " + weatherinfoarray[5], templow: "Low: " + weatherinfoarray[6], temphigh: "High: " + weatherinfoarray[7], date: String(weatherinfoarray[8]))
            weatherforcasts.append(one)
            
            let two = weatherInfo(location: weatherinfoarray[1] + ", " + weatherinfoarray[2], forecast: "Forecast: " + weatherinfoarray[9], image: String(weatherinfoarray[10]), rain: "Rain: " + weatherinfoarray[11], templow: "Low: " + weatherinfoarray[12], temphigh: "High: " + weatherinfoarray[13], date: String(weatherinfoarray[14]))
            weatherforcasts.append(two)

            
             let three = weatherInfo(location: weatherinfoarray[1] + ", " + weatherinfoarray[2], forecast: "Forecast: " + weatherinfoarray[15], image: String(weatherinfoarray[16]), rain: "Rain: " + weatherinfoarray[17], templow: "Low: " + weatherinfoarray[18], temphigh: "High: " + weatherinfoarray[19], date: String(weatherinfoarray[20]))
            weatherforcasts.append(three)
            
            let four = weatherInfo(location: weatherinfoarray[1] + ", " + weatherinfoarray[2], forecast: "Forecast: " + weatherinfoarray[21], image: String(weatherinfoarray[22]), rain: "Rain: " + weatherinfoarray[23], templow: "Low: " + weatherinfoarray[24], temphigh: "High: " + weatherinfoarray[25], date: String(weatherinfoarray[26]))
            weatherforcasts.append(four)
            
            let five = weatherInfo(location: weatherinfoarray[1] + ", " + weatherinfoarray[2], forecast: "Forecast: " + weatherinfoarray[27], image: String(weatherinfoarray[28]), rain: "Rain: " + weatherinfoarray[29], templow: "Low: " + weatherinfoarray[30], temphigh: "High: " + weatherinfoarray[31], date: String(weatherinfoarray[32]))
            weatherforcasts.append(five)
            
           let six = weatherInfo(location: weatherinfoarray[1] + ", " + weatherinfoarray[2], forecast: "Forecast: " + weatherinfoarray[33], image: String(weatherinfoarray[34]), rain: "Rain: " + weatherinfoarray[35], templow: "Low: " + weatherinfoarray[36], temphigh: "High: " + weatherinfoarray[37], date: String(weatherinfoarray[38]))
            weatherforcasts.append(six)
            
             let seven = weatherInfo(location: weatherinfoarray[1] + ", " + weatherinfoarray[2], forecast: "Forecast: " + weatherinfoarray[39], image: String(weatherinfoarray[40]), rain: "Rain: " + weatherinfoarray[41], templow: "Low: " + weatherinfoarray[42], temphigh: "High: " + weatherinfoarray[43], date: String(weatherinfoarray[44]))
            weatherforcasts.append(seven)
        }
        
    }
    
}
