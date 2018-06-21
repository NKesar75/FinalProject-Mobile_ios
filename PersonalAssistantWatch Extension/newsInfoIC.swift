//
//  newsInfoIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/7/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import AVFoundation

class newsInfoIC: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var newsInfoHeadline: WKInterfaceLabel!
    @IBOutlet var newsInfoSnippet: WKInterfaceLabel!
    
    var newsURl : String = ""
    var session:WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let newsData = context as? newsInfo
        {
            newsInfoHeadline.setText(newsData.title)
            newsInfoSnippet.setText(newsData.description)
            self.newsURl = newsData.url
            print(self.newsURl)
        }
        if(WCSession.isSupported()){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }

        let textTospeech = AVSpeechUtterance(string: "If you wish to read more information about your news selection please press read more")
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
    
    @IBAction func newsInfoReadMore()
    {
        if(WCSession.isSupported())
        {
            self.session.sendMessage(["More": self.newsURl], replyHandler: nil, errorHandler: nil)
        }
        presentController(withName: "newsReadMoreIdentifier", context: nil)
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}
