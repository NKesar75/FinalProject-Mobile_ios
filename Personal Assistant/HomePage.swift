//
//  HomePage.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 3/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase

class HomePage: UIViewController {

    @IBOutlet weak var ViewConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var sideview: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       blurView.layer.cornerRadius = 15
       sideview.layer.shadowColor = UIColor.black.cgColor
       sideview.layer.shadowOpacity = 0.8
        sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        ViewConstarint.constant = -175
    }

    @IBAction func panguesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if ViewConstarint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.ViewConstarint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }else{ //swipe left
                if ViewConstarint.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.ViewConstarint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended{
            if ViewConstarint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.ViewConstarint.constant = -175
                    self.view.layoutIfNeeded()
            })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.ViewConstarint.constant = 0
                    self.view.layoutIfNeeded()
            })
        
        
    }
    //    @IBAction func Signout(_ sender: Any) {
//        do {
//            try Auth.auth().signOut()
//            performSegue(withIdentifier: "Signout_seg", sender: nil)
//        } catch {
//            print(error)
//        }
//    }
}
}
}
