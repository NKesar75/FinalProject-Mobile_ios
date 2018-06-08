//
//  googleReadMoreIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/8/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class googleReadMoreIC: WKInterfaceController, WCSessionDelegate {

    var session:WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if(WCSession.isSupported()){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        if(WCSession.isSupported())
        {
            self.session.sendMessage(["More": googleinfoIC.googleUrl], replyHandler: nil, errorHandler: nil)
        }

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

}
