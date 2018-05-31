//
//  RemberWebview.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/31/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import WebKit

class RemberWebview: UIViewController {

    @IBOutlet weak var remberweb: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RemberWebview.dismissKeyboard))
          tap.cancelsTouchesInView = false
        // Do any additional setup after loading the view.
        setpage()
    }

    func setpage (){
       var typeofcontent = Rember.typeurlofrember.split(separator: ",")
        if typeofcontent[0] == "Youtube"{
            let url = URL(string: "https://www.youtube.com/embed/\(String(typeofcontent[1]))")
            remberweb.load(URLRequest(url: url!))
        }
        else{
            let url = URL(string: String(typeofcontent[1]))
            remberweb.load(URLRequest(url: url!))
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}
