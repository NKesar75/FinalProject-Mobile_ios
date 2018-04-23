//
//  Youtube.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/18/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import WebKit

class Youtube: UIViewController {

    @IBOutlet weak var Sideview: UIView!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var Blur_View: UIVisualEffectView!
    @IBOutlet weak var View_Constarint: NSLayoutConstraint!
    @IBOutlet weak var youtubeview: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Blur_View.layer.cornerRadius = 15
        Sideview.layer.shadowColor = UIColor.black.cgColor
        Sideview.layer.shadowOpacity = 0.8
        Sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        View_Constarint.constant = -175
        self.menu.isHidden = false
        
        setvideo(videoid: "QrVjFfP4pak")
      
    }
    
    func setvideo (videoid:String){
        let url = URL(string: "https://www.youtube.com/embed/\(videoid)")
        youtubeview.load(URLRequest(url: url!))
    }
    
    
    @IBAction func menupressed(_ sender: Any) {
        
        if View_Constarint.constant < 20 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_Constarint.constant = 0
                self.view.layoutIfNeeded()
                self.menu.isHidden = true
            })
        }
    }
    
    @IBAction func Youtubepressed(_ sender: UIButton) {
        if View_Constarint.constant > -175 {
            UIView.animate(withDuration: 0.2, animations: {
                self.View_Constarint.constant = -175
                self.view.layoutIfNeeded()
                self.menu.isHidden = false
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func panguesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if View_Constarint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_Constarint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        self.menu.isHidden = true
                    })
                }
            }else{ //swipe left
                if View_Constarint.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.View_Constarint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended{
            if View_Constarint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_Constarint.constant = -175
                    self.view.layoutIfNeeded()
                    self.menu.isHidden = false
                })
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.View_Constarint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


