//
//  chatBotIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation
import WatchConnectivity

class chatBotIC: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var questionLabel: WKInterfaceLabel!
    @IBOutlet var answerLabel: WKInterfaceLabel!
    
    //var printQuestion : String?
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
    @IBAction func askBtn()
    {
        let textChoices = ["What is your name", "What can you help me with", "Good Morning"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.plain,
                                   completion: {(results) -> Void in if results != nil && results!.count > 0 { //selection made
                                    let aResult = results?[0] as? String
//                                    self.printQuestion = aResult
//                                    aResult = aResult!.lowercased()
//                                    aResult = aResult!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                                    print(aResult!)
                                    self.questionLabel.setText(aResult)
                                    if(WCSession.isSupported())
                                    {
                                        self.session.sendMessage(["chatBotQuestion": aResult!], replyHandler: nil, errorHandler: nil)
                                    }
                                    }
        }
        )
    }
    
     func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        let chatAns = message["chatBotAnswer"]! as! String
        print(chatAns)
        answerLabel.setText(chatAns)
        
        let textTospeech = AVSpeechUtterance(string: chatAns)
        textTospeech.voice = AVSpeechSynthesisVoice(language: "en-US")
        textTospeech.rate = 0.5
        
        let synthersizer = AVSpeechSynthesizer()
        synthersizer.speak(textTospeech)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}
