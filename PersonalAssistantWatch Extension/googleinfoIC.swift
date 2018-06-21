//
//  googleinfoIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/7/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import AVFoundation

class googleinfoIC: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var googleInfoTitle: WKInterfaceLabel!
    @IBOutlet var googleInfoSnippet: WKInterfaceLabel!
    
    var googleUrl : String = ""
    var session:WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let googleData = context as? googleSearchInfo
        {
            googleInfoTitle.setText(googleData.title)
            googleInfoSnippet.setText(googleData.snippet)
            self.googleUrl = googleData.url
            print(self.googleUrl)
        }
        if(WCSession.isSupported()){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        
        let textTospeech = AVSpeechUtterance(string: "If you wish to read more information about your search please press read more")
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

    @IBAction func readMoreBtn()
    {
        if(WCSession.isSupported())
        {
            self.session.sendMessage(["More": self.googleUrl], replyHandler: nil, errorHandler: nil)
        }
        presentController(withName: "googleReadMoreIdentifier", context: nil)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
