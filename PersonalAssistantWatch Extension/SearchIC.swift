//
//  SearchIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Hector Kesar on 5/29/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation


class SearchIC: WKInterfaceController {

    
    
    struct googlesearchinfo{
        var title : String
        var snippet : String
        var url : String
    }
    var googlesearches:[googlesearchinfo] = []
    
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
        if HomePageIC.requestinfo != "" {
            let weatherinfoarray = HomePageIC.requestinfo.split(separator: ",")
            //0 key //1 city //2 state //3 condition //4 url //5 rain //6 temp low //7 temp high //8 month/date/year //9 repeat condition
            print(weatherinfoarray)
            if Servercalls.serverjson["key"].string != nil && Servercalls.serverjson["key"] == "google" {
                googlesearches.removeAll()
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][0]["title"].string!, snippet: Servercalls.serverjson["results"][0]["snippet"].string!, url: Servercalls.serverjson["results"][0]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][1]["title"].string!, snippet: Servercalls.serverjson["results"][1]["snippet"].string!, url: Servercalls.serverjson["results"][1]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][2]["title"].string!, snippet: Servercalls.serverjson["results"][2]["snippet"].string!, url: Servercalls.serverjson["results"][2]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][3]["title"].string!, snippet: Servercalls.serverjson["results"][3]["snippet"].string!, url: Servercalls.serverjson["results"][3]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][4]["title"].string!, snippet: Servercalls.serverjson["results"][4]["snippet"].string!, url: Servercalls.serverjson["results"][4]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][5]["title"].string!, snippet: Servercalls.serverjson["results"][5]["snippet"].string!, url: Servercalls.serverjson["results"][5]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][6]["title"].string!, snippet: Servercalls.serverjson["results"][6]["snippet"].string!, url: Servercalls.serverjson["results"][6]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][7]["title"].string!, snippet: Servercalls.serverjson["results"][7]["snippet"].string!, url: Servercalls.serverjson["results"][7]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][8]["title"].string!, snippet: Servercalls.serverjson["results"][8]["snippet"].string!, url: Servercalls.serverjson["results"][8]["url"].string!))
                googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][9]["title"].string!, snippet: Servercalls.serverjson["results"][9]["snippet"].string!, url: Servercalls.serverjson["results"][9]["url"].string!))
            }
        }
    }
}
