//
//  HomePageIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 5/24/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreLocation
import MapKit

class HomePageIC: WKInterfaceController, WCSessionDelegate, CLLocationManagerDelegate {

    @IBOutlet var requestLabel: WKInterfaceLabel!
    var aResult : String?
    var session:WCSession!
    
    //Global Variable to acess request infor on each page
    static var requestinfo: String = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        //Created Session to connect with the Phone
        if(WCSession.isSupported()){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func requestBtn()
    {
        let textChoices = ["What is the Weather","Play Despacito","Search for Game of Thrones"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.plain,
                                   completion: {(results) -> Void in if results != nil && results!.count > 0 { //selection made
                                    self.aResult = results?[0] as? String
                                    self.aResult = self.aResult!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                                    //Send MEssage to Phone
                                    if(WCSession.isSupported())
                                    {
                                        self.session.sendMessage(["Request": self.aResult!], replyHandler: nil, errorHandler: nil)
                                    }
                                    }
        }
        )
    }
    
    //function to receive the message from the Phone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        let msgfromPhone = message["key"]! as? String
        print(msgfromPhone!)
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
