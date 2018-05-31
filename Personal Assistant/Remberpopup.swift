//
//  Remberpopup.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/31/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class Remberpopup: UIViewController {

    @IBOutlet weak var rembertitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        rembertitle.text = Rember.titleofrember
        
        self.showAnimate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Deletebuttonpressed(_ sender: Any) {
        if rembertitle.text != "No Link Selected"{
            var listtitle = Rember.titleofrember
            
            listtitle = listtitle.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "$", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "[", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "]", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "#", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
            
            
            let temp: Remberfirebasehelperclass = Remberfirebasehelperclass()
            temp.deletefromfirebase(link: listtitle)
            
            self.removeAnimate()
            
        }
        
    }
    
    @IBAction func cancelbuttonpressed(_ sender: Any) {
         self.removeAnimate()
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
