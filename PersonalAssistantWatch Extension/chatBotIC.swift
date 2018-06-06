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

class chatBotIC: WKInterfaceController {

    @IBOutlet var questionLabel: WKInterfaceLabel!
    @IBOutlet var answerLabel: WKInterfaceLabel!
    
    var printQuestion : String?
    
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
    @IBAction func askBtn()
    {
        let textChoices = ["What is your name", "What can you help me with", "Good Morning"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.plain,
                                   completion: {(results) -> Void in if results != nil && results!.count > 0 { //selection made
                                    var aResult = results?[0] as? String
                                    self.printQuestion = aResult
                                    aResult = aResult!.lowercased()
                                    aResult = aResult!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                                    print(aResult!)
                                    self.questionLabel.setText(self.printQuestion!)
                                    self.answerLabel.setText("Hello, My name is Maya")
                                    
                                    let textTospeech = AVSpeechUtterance(string: "Hello, My name is Maya")
                                    textTospeech.voice = AVSpeechSynthesisVoice(language: "en-US")
                                    textTospeech.rate = 0.5
                                    
                                    let synthersizer = AVSpeechSynthesizer()
                                    synthersizer.speak(textTospeech)
                                    }
        }
        )
    }
    
}
