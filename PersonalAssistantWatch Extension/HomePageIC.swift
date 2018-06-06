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
    
    @IBAction func newsBtn()
    {
        pushController(withName: "newsIdentifier", context: nil)
    }
    
    @IBAction func stocksBtn()
    {
        pushController(withName: "stocksIdentifier", context: nil)
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
        let textChoices = ["What is the Weather", "Search for Avengers"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.plain,
                                   completion: {(results) -> Void in if results != nil && results!.count > 0 { //selection made
                                    self.aResult = results?[0] as? String
                                    self.aResult = self.aResult!.lowercased()
                                    self.aResult = self.aResult!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                                    print(self.aResult!)
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
                                        self.session.sendMessage(["Request": self.aResult!], replyHandler: nil, errorHandler: nil)
                                    }
                                    }
        }
        )
    }
    
    //function to receive the message from the Phone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
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
