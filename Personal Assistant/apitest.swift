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

class apitest: UIViewController {
    
    @IBOutlet weak var usermessage: UILabel!
    @IBOutlet weak var sendbuttonframe: UIButton!
    @IBOutlet weak var apiresponse: UILabel!
    @IBOutlet weak var usertext: UITextField!
    
    var session: WCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        self.usertext.frame = CGRect(x: 0, y: self.view.frame.maxY - 50, width: self.view.frame.maxX - 85, height: 50)
        self.sendbuttonframe.frame = CGRect(x: self.usertext.frame.maxX, y: self.usertext.frame.minY, width: 85, height: 50)
    }
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            self.apiresponse.text = "Maya: " + text
        }, completion: nil)
    }
    
    func askmaya(){
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
        if self.usertext.text != "" && self.usertext.text != " " && self.usertext.text != nil {
            usermessage.text = "You: " + self.usertext.text!
        }
        usertext.text = ""
    }
    
    @IBAction func userquestionenterpressed(_ sender: Any) {
        askmaya()
    }
    
    @IBAction func sendbutton(_ sender: Any) {
        askmaya()
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.usertext.frame = CGRect(x: keyboardFrame.minX, y: keyboardFrame.minY - 50, width: self.view.frame.maxX - 85, height: 50)
        self.sendbuttonframe.frame = CGRect(x: self.usertext.frame.maxX, y: self.usertext.frame.minY, width: 85, height: 50)
        print("keyboardFrame: \(keyboardFrame)")
    }
    
}
