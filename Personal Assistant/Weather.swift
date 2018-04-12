//
//  Weather.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/11/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class Weather: UIViewController {
    @IBOutlet weak var Sideview: UIView!
    @IBOutlet weak var Blur_View: UIVisualEffectView!
    @IBOutlet weak var View_Constraint: NSLayoutConstraint!
    @IBOutlet weak var menu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Blur_View.layer.cornerRadius = 15
        Sideview.layer.shadowColor = UIColor.black.cgColor
        Sideview.layer.shadowOpacity = 0.8
        Sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        View_Constraint.constant = -175
        self.menu.isHidden = false
        
        // Do any additional setup after loading the view.
    }

    @IBAction func weatherpressedonweather(_ sender: UIButton) {
        if View_Constraint.constant > -175 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_Constraint.constant = -175
                self.view.layoutIfNeeded()
                self.menu.isHidden = false
            })
        }
    }
    @IBAction func menubuttonpressed(_ sender: UIButton) {
        if View_Constraint.constant < 20 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_Constraint.constant = 0
                self.view.layoutIfNeeded()
                self.menu.isHidden = true
            })
        }
    }
    @IBAction func Pan_guuesture(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if View_Constraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_Constraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        self.menu.isHidden = true
                    })
                }
            }else{ //swipe left
                if View_Constraint.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_Constraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended{
            if View_Constraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_Constraint.constant = -175
                    self.view.layoutIfNeeded()
                    self.menu.isHidden = false
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_Constraint.constant = 0
                    self.view.layoutIfNeeded()
                })
    }
        }
    }
}
