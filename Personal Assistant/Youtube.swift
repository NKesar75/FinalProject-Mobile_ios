//
//  Youtube.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/18/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import CoreLocation
import Speech
import SwiftyJSON
class Youtube: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var Titleofvideo: UILabel!
    @IBOutlet weak var Searchfortext: UITextField!
    
    var serverjson = JSON()
    
    @IBOutlet weak var youtubeview: WKWebView!
    var audioRecorder: AVAudioRecorder!
    var player : AVAudioPlayer?
    var isRecording = false
    let locationManager:CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String?
    var state: String?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var stringtoserver: String?
    
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    var video_id:String = ""
    var video_title:String = ""
    @IBOutlet weak var remberbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.FetchPreviousCall()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Youtube.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func setvideo (videoid:String, videotitle:String){
        if videoid != video_id {
            video_id = videoid
            video_title = videotitle
            remberbutton.setTitle("Remember",for: .normal)
        }
        let url = URL(string: "https://www.youtube.com/embed/\(videoid)")
        youtubeview.load(URLRequest(url: url!))
        Titleofvideo.text = videotitle
    }
    
    
    @IBAction func voicebuttonpressed(_ sender: UIButton) {
        if remberbutton.titleLabel?.text != "Remembered" && video_id != "" && video_id != " "{
            let helper: Remberfirebasehelperclass = Remberfirebasehelperclass()
            
            video_title = video_title.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
            video_title = video_title.replacingOccurrences(of: "$", with: " ", options: .literal, range: nil)
            video_title = video_title.replacingOccurrences(of: "[", with: " ", options: .literal, range: nil)
            video_title = video_title.replacingOccurrences(of: "]", with: " ", options: .literal, range: nil)
            video_title = video_title.replacingOccurrences(of: "#", with: " ", options: .literal, range: nil)
            video_title = video_title.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
            
            helper.pushtofirebase(link: video_title, type: ("Youtube," + video_id))
            remberbutton.setTitle("Remembered",for: .normal)
        }
        
    }
    @IBAction func Searchfortextyoutube(_ sender: UIButton) {
        if Searchfortext.text != "" && Searchfortext.text != " "{
            activityindactor.frame.origin = CGPoint(x: self.view.center.x , y: self.view.center.y + 125 )
            activityindactor.hidesWhenStopped = true
            activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            view.addSubview(activityindactor)
            self.activityindactor.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            var servermetod = "play " + Searchfortext.text!
            servermetod = servermetod.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            
            let urlString = "https://personalassistant-ec554.appspot.com/recognize/" + servermetod + "/" + self.state! + "/" + self.city!
            guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { (data, reponse, err) in
                guard let data = data else { return }
                do {
                    
                    self.serverjson = try JSON(data: data)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                
                }.resume()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
                if self.serverjson["key"].string != nil && self.serverjson["key"] == "youtube" {
                    
                    self.FetchPreviousCall()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityindactor.removeFromSuperview()
                    
                    
                }else{
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityindactor.removeFromSuperview()
                }
            })
            
            
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                self.placemark = placemark.last
            }
            if let _:CLLocation = location {
                if let placemark = self.placemark {
                    if let city = placemark.locality, !city.isEmpty {
                        self.city = city
                    }
                    if let state = placemark.administrativeArea, !state.isEmpty {
                        
                        self.state = state
                    }
                }
                if self.city != nil && self.state != nil {
                    self.city = self.city!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                }
            }
        })
    }
    
    func FetchPreviousCall(){
        if self.serverjson["key"].string != nil && self.serverjson["key"] == "youtube" {
            setvideo(videoid: self.serverjson["id"].string!, videotitle: self.serverjson["title"].string!)
        }
    }
    
}




