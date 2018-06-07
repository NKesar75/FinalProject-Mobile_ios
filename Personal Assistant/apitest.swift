//
//  apitest.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation
import WatchConnectivity

class apitest: UIViewController, WCSessionDelegate {

    @IBOutlet weak var usermessage: UILabel!
    @IBOutlet weak var sendbuttonframe: UIButton!
    @IBOutlet weak var apiresponse: UILabel!
    @IBOutlet weak var usertext: UITextField!
    
    var session: WCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        // Do any additional setup after loading the view.
        
        if(WCSession.isSupported()){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
        
    }

    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.apiresponse.text = text
        }, completion: nil)
    }
    @IBAction func sendbutton(_ sender: Any) {
        let request = ApiAI.shared().textRequest()
        
        if let text = self.usertext.text, text != "" {
            request?.query = text
        } else {
            return
        }

        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
                
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        usermessage.text = usertext.text
        usertext.text = ""
        
    }
    
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        usertext.frame = CGRect(x: keyboardFrame.minX, y: keyboardFrame.minY - 50, width: self.view.frame.maxX - 85, height: 50)
        sendbuttonframe.frame = CGRect(x: usertext.frame.maxX, y: usertext.frame.minY, width: 85, height: 50)
        print("keyboardFrame: \(keyboardFrame)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        DispatchQueue.main.async
        {
            let chatQuestion = message["chatBotQuestion"]! as? String
            var sendtowatch : String = ""
            
            let request = ApiAI.shared().textRequest()
            
            if let text = self.usertext.text, text != "" {
                request?.query = text
            } else {
                return
            }
            
            request?.setMappedCompletionBlockSuccess({ (request, response) in
                let response = response as! AIResponse
                if let textResponse = response.result.fulfillment.speech {
                    self.speechAndText(text: textResponse)
                    
                }
            }, failure: { (request, error) in
                print(error!)
            })
            
            ApiAI.shared().enqueue(request)
            
            //session.sendMessage(["chatBotAnswer": sendtowatch], replyHandler: nil, errorHandler: nil)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}
