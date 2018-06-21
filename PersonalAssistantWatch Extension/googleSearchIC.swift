//
//  googleSearchIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class googleSearchIC: WKInterfaceController {

    @IBOutlet var googleTable: WKInterfaceTable!
    
    var googleList: [googleSearchInfo] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        loadDataintoTable()
        
        let textTospeech = AVSpeechUtterance(string: "Your Search result is as follows")
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
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int)
    {
        pushController(withName: "googleinfoIdentifier", context: googleList[rowIndex])
    }

    func loadDataintoTable()
    {
        fetchperviouscall()
        googleTable.setNumberOfRows(googleList.count, withRowType: "googleSearchRowController")
        for (index, _) in googleList.enumerated()
        {
            if let rowController = googleTable.rowController(at: index) as? googleSearchRowController
            {
                rowController.googleTitle.setText(googleList[index].title)
            }
        }
    }
    
    func fetchperviouscall()
    {
        if HomePageIC.requestinfo != ""
        {
            let googleArray = HomePageIC.requestinfo.split(separator: "\u{1D6FF}")
            print(googleArray.count)
            for i in stride(from: 1, to: 30, by: 3)
            {
                googleList.append(googleSearchInfo(title: String(googleArray[i]), snippet: String(googleArray[i+1]), url: String(googleArray[i+2])))
            }
        }
    }
}
