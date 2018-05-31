//
//  Searchpopup.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/31/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase

class Searchpopup: UIViewController {

    @IBOutlet weak var filename: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        filename.text = Search.titleofsearch
        
        self.showAnimate()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func canelbuttonpressed(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func savebuttonpressed(_ sender: Any) {
        if filename.text != "No Link Selected"{
            var listtitle = Search.titleofsearch
            let listlinc = Search.urlofsearch
            
            listtitle = listtitle.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "$", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "[", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "]", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "#", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
            
            
            let temp: Remberfirebasehelperclass = Remberfirebasehelperclass()
            temp.pushtofirebase(link: listtitle, type: "Google," + listlinc)
            
            self.removeAnimate()
            
        }
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    

}
