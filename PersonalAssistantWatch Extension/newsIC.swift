//
//  newsIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import AVFoundation

class newsIC: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var newsChannelTable: WKInterfaceTable!
    @IBOutlet var loadingAnimation: WKInterfaceImage!
    
    var titles:[String] = ["ABC News", "Apple", "BBC News", "BBC Sports", "Bitcoin", "Bleacher Reports", "Bloomberg", "Breitbart", "Business", "Business Insider", "Buzz Feed", "CBS News", "CNN", "Daily Mail", "Entertainment Week", "ESPN", "Financial Times", "Four Four Two", "Fox News", "Fox Sports", "Google News", "Hacker News", "IGN", "Medical News", "Metro", "MSNBC", "MTV", "National Geographics", "National Review", "NBC News", "New Scientist",  "News 24", "NFL News", "NHL News", "Reddit", "Talk Sports", "TechCrunch", "The New York Times", "USA Today", "Vice News", "Wall Street", "Washington"]
    
    var session:WCSession!
    static var newsData : String = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        loadDataintoTable()
        
        let textTospeech = AVSpeechUtterance(string: "Here are some of the leading news channels for you to keep updated with the current affairs.")
        textTospeech.voice = AVSpeechSynthesisVoice(language: "en-US")
        textTospeech.rate = 0.5
        
        let synthersizer = AVSpeechSynthesizer()
        synthersizer.speak(textTospeech)
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
    
    func loadDataintoTable()
    {
        newsChannelTable.setNumberOfRows(titles.count, withRowType: "newschannelRowController")
        for (index, _) in titles.enumerated()
        {
            if let rowController = newsChannelTable.rowController(at: index) as? newsRowController
            {
                rowController.newsChannelName.setText(titles[index])
                rowController.newsChannelImg.setImageNamed(titles[index])
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int)
    {
        let selectedRow = titles[rowIndex]
        if(WCSession.isSupported())
        {
            self.newsChannelTable.setHidden(true)
            self.loadingAnimation.setHidden(false)
            self.loadingAnimation.setImageNamed("loading")
            self.loadingAnimation.startAnimatingWithImages(in: NSRange(location: 0, length: 137), duration: 15, repeatCount: Int.max)
            self.session.sendMessage(["NewsRequest": selectedRow], replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        if message["NewsInfo"] != nil
        {
            newsIC.newsData = message["NewsInfo"]! as! String
            print(newsIC.newsData)
            let newsKey = newsIC.newsData.split(separator: "\u{1D6FF}")
            print(newsKey)
            if newsKey[0] != nil && newsKey[0] == "News"
            {
                pushController(withName: "newsHeadlineIdentifier", context: nil)
            }
        }
        loadingAnimation.setHidden(true)
        newsChannelTable.setHidden(false)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }

}
