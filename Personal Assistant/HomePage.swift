//
//  HomePage.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 3/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import CoreLocation
import MapKit

class HomePage: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var menubutton: UIButton!
    @IBOutlet weak var ViewConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var sideview: UIView!
    
    @IBOutlet weak var voice_button: UIButton!
    var audioRecorder: AVAudioRecorder?
    var player : AVAudioPlayer?
    var isRecording = false
    let locationManager:CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String?
    var state: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       blurView.layer.cornerRadius = 15
       sideview.layer.shadowColor = UIColor.black.cgColor
       sideview.layer.shadowOpacity = 0.8
       sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
       ViewConstarint.constant = -175
        self.menubutton.isHidden = false
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        AVAudioSession.sharedInstance().requestRecordPermission () {
             [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
                
            } else {
                // User denied microphone. Tell them off!
                
            }
        }
        //locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locations[0]
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            // always good to check if no error
            // also we have to unwrap the placemark because it's optional
            // I have done all in a single if but you check them separately
            if error == nil, let placemark = placemarks, !placemark.isEmpty {
                self.placemark = placemark.last
            }
            // a new function where you start to parse placemarks to get the information you need
            // here we check if location manager is not nil using a _ wild card
            if let _:CLLocation = location {
                // unwrap the placemark
                if let placemark = self.placemark {
                    // wow now you can get the city name. remember that apple refers to city name as locality not city
                    // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
                    if let city = placemark.locality, !city.isEmpty {
                        // here you have the city name
                        // assign city name to our iVar
                        self.city = city
                    }
                    // the same story optionalllls also they are not empty
                    if let state = placemark.administrativeArea, !state.isEmpty {
                        
                        self.state = state
                    }
                    
                }
                
                self.city = self.city!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                print(self.city)
                print(self.state)
                
            } else {
                // add some more check's if for some reason location manager is nil
            }
            
            
        })

    }
    
    
    @IBAction func HomepressedonHome(_ sender: UIButton) {
        if ViewConstarint.constant > -175 {
            UIView.animate(withDuration: 0.2, animations: {
                self.ViewConstarint.constant = -175
                self.view.layoutIfNeeded()
                self.menubutton.isHidden = false
            })
        }
    }
    
    @IBAction func menubuttonclicked(_ sender: UIButton) {
        if ViewConstarint.constant < 20 {
            UIView.animate(withDuration: 0.2, animations: {
                self.ViewConstarint.constant = 0
                 self.view.layoutIfNeeded()
                self.menubutton.isHidden = true
            })
        }
    }
    @IBAction func voicebutton(_ sender: UIButton) {
       
        if isRecording {
            finishRecording()
        }else {
            startRecording()
        }
    }
    
    
    func startRecording() {
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
          
            let settings = [
                AVFormatIDKey : NSNumber.init(value: kAudioFormatAppleLossless),
                AVSampleRateKey : NSNumber.init(value: 44100.0),
                AVNumberOfChannelsKey : NSNumber.init(value: 2),
                AVEncoderBitRateKey: NSNumber.init(value: 16),
                AVEncoderAudioQualityKey : NSNumber.init(value: AVAudioQuality.high.rawValue)
            ]
            // 4. create the audio recording, and assign ourselves as the delegate
            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            //5. Changing recording bool to true
            isRecording = true
        }
        catch let error {
            // failed to record!
        }
    }
    
    // Stop recording
    func finishRecording() {
        audioRecorder?.stop()
        isRecording = false
        let url = getAudioFileUrl()
        
        do {
            // AVAudioPlayer setting up with the saved file URL
            let sound = try AVAudioPlayer(contentsOf: url)
            self.player = sound
            
            // Here conforming to AVAudioPlayerDelegate
            sound.delegate = self
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("error loading file")
            // couldn't load file :(
        }
        let storage = Storage.storage()
        let storageRef = storage.reference()

        let voiceref = storageRef.child("ios_voice.amr")
        voiceref.putFile(from: url)
    }
    
    // Path for saving/retreiving the audio file
    func getAudioFileUrl() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording.m4a")
        return audioUrl
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            finishRecording()
        }else {
            // Recording interrupted by other reasons like call coming, reached time limit.
        }
            }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            
        }else {
            // Playing interrupted by other reasons like call coming, the sound has not finished playing.
        }
       
    }

    @IBAction func panguesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if ViewConstarint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.ViewConstarint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        self.menubutton.isHidden = true
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
                    self.menubutton.isHidden = false
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
