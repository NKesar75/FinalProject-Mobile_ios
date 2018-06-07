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

class HomePageIC: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var requestBtnHide: WKInterfaceButton!
    @IBOutlet var newsBtnHide: WKInterfaceButton!
    @IBOutlet var stocksBtnHide: WKInterfaceButton!
    @IBOutlet var uberBtnHide: WKInterfaceButton!
    @IBOutlet var chatBotBtnHide: WKInterfaceButton!
    
    
    @IBOutlet var loadingAnimation: WKInterfaceImage!
    
    var session:WCSession!
    
    //Global Variable to acess request infor on each page
    static var requestinfo: String = ""
    static var stockInfo : String = ""
    static var newsInfo : String = ""
    
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
    
    @IBAction func newsBtn()
    {
        if(WCSession.isSupported())
        {
            self.requestBtnHide.setHidden(true)
            self.uberBtnHide.setHidden(true)
            self.chatBotBtnHide.setHidden(true)
            self.newsBtnHide.setHidden(true)
            self.stocksBtnHide.setHidden(true)
            self.loadingAnimation.setHidden(false)
            self.loadingAnimation.setImageNamed("loading")
            self.loadingAnimation.startAnimatingWithImages(in: NSRange(location: 0, length: 137), duration: 15, repeatCount: Int.max)
            self.session.sendMessage(["StockRequest": "User wants to see the news"], replyHandler: nil, errorHandler: nil)
        }
    }
    
    @IBAction func stocksBtn()
    {
        if(WCSession.isSupported())
        {
            self.requestBtnHide.setHidden(true)
            self.uberBtnHide.setHidden(true)
            self.chatBotBtnHide.setHidden(true)
            self.newsBtnHide.setHidden(true)
            self.stocksBtnHide.setHidden(true)
            self.loadingAnimation.setHidden(false)
            self.loadingAnimation.setImageNamed("loading")
            self.loadingAnimation.startAnimatingWithImages(in: NSRange(location: 0, length: 137), duration: 15, repeatCount: Int.max)
            self.session.sendMessage(["StockRequest": "User wants to see the stocks"], replyHandler: nil, errorHandler: nil)
        }
    }
    
    @IBAction func uberBtn()
    {
        pushController(withName: "uberIdentifier", context: nil)
    }
    
    @IBAction func chatBotBtn()
    {
        pushController(withName: "chatBotIdentifier", context: nil)
    }
    
    @IBAction func requestBtn()
    {
        let textChoices = ["What is the Weather", "Search for Full Sail University", "Play Spiderman PS4"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.plain,
                                   completion: {(results) -> Void in if results != nil && results!.count > 0 { //selection made
                                    var aResult = results?[0] as? String
                                    aResult = aResult!.lowercased()
                                    aResult = aResult!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                                    print(aResult!)
                                    //Send MEssage to Phone
                                    if(WCSession.isSupported())
                                    {
                                        self.requestBtnHide.setHidden(true)
                                        self.uberBtnHide.setHidden(true)
                                        self.chatBotBtnHide.setHidden(true)
                                        self.newsBtnHide.setHidden(true)
                                        self.stocksBtnHide.setHidden(true)
                                        self.loadingAnimation.setHidden(false)
                                        self.loadingAnimation.setImageNamed("loading")
                                        self.loadingAnimation.startAnimatingWithImages(in: NSRange(location: 0, length: 137), duration: 15, repeatCount: Int.max)
                                        self.session.sendMessage(["Request": aResult!], replyHandler: nil, errorHandler: nil)
                                    }
                                    }
        }
        )
    }
    
    //function to receive the message from the Phone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if message["key"] != nil
        {
        HomePageIC.requestinfo = message["key"]! as! String
        print( HomePageIC.requestinfo)
        let keyofmsg =  HomePageIC.requestinfo.split(separator: ",")
        print(keyofmsg)
        if keyofmsg[0] != nil{
            switch(keyofmsg[0]){
            case "weather":
                pushController(withName: "WeatherIdentifier", context: nil)
                break
            case "google":
                pushController(withName: "googleSearchIdentifier", context: nil)
                break
            case "youtube":
                pushController(withName: "youtubeIdentifier", context: nil)
                break
            default:
                break
            }
        }
        }
        else if message["StockInfo"] != nil
        {
            HomePageIC.stockInfo = message["StockInfo"]! as! String
            print(HomePageIC.stockInfo)
            pushController(withName: "stocksIdentifier", context: nil)
        }
        else if message["NewsInfo"] != nil
        {
            HomePageIC.newsInfo = message["NewsInfo"]! as! String
            print(HomePageIC.newsInfo)
            pushController(withName: "newsIdentifier", context: nil)
        }
        loadingAnimation.setHidden(true)
        requestBtnHide.setHidden(false)
        uberBtnHide.setHidden(false)
        chatBotBtnHide.setHidden(false)
        newsBtnHide.setHidden(false)
        stocksBtnHide.setHidden(false)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
