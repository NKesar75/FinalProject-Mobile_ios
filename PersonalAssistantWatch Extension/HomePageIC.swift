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

class HomePageIC: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var requestLabel: WKInterfaceLabel!
    var aResult : String?
    var session:WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
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
                                    //print(self.aResult!)
                                    //self.myLabel.setText(self.aResult)
                                    if(WCSession.isSupported()){
                                        self.session.sendMessage(["Request":self.aResult!], replyHandler: nil, errorHandler: nil)
                                    }
                                    }
        }
        )
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        self.requestLabel.setText(message["key"]! as? String)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
