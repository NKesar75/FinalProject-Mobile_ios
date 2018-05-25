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
import Speech
import SwiftyJSON
import WatchConnectivity

class HomePage: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, SFSpeechRecognizerDelegate, WCSessionDelegate{
    
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var voice_button: UIButton!
    @IBOutlet weak var sideview: UIView!
    @IBOutlet weak var blurview: UIVisualEffectView!
    @IBOutlet weak var viewconstraint: NSLayoutConstraint!
    
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
    var voicequestion: Bool?
    var isfirsttimecall: Bool?
    
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var stringtoserver: String?
    
    //WatchConnectivity session variable
    var session: WCSession!
    var resuestfromwatch: String!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePage.navagitiongone))
        tap.cancelsTouchesInView = true
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
           
                switch authStatus {
                case .authorized:
                    print("authorized")
                case .denied:
                     print("not authorized")
                case .restricted:
                    print("limted authorizion")
                case .notDetermined:
                     print("no choice yet authorizion")
            }
        }
        
        
        view.addGestureRecognizer(tap)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        voicequestion = false
        isfirsttimecall = true
        
        AVAudioSession.sharedInstance().requestRecordPermission () {
             [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
                
            } else {
                // User denied microphone. Tell them off!
                
            }
        }
        //locationManager.stopUpdatingLocation()
        
        blurview.layer.cornerRadius = 15
        sideview.layer.shadowColor = UIColor.black.cgColor
        sideview.layer.shadowOpacity = 0.8
        sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        viewconstraint.constant = -175
        
        //WatchConnectivity Session created
        if(WCSession.isSupported()){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    @objc func navagitiongone() {
        if viewconstraint.constant > -175 {
            UIView.animate(withDuration: 0.2, animations: {
                self.viewconstraint.constant = -175
                self.view.layoutIfNeeded()
                self.menu.isHidden = false
            })
        }
    }

    @IBAction func menubuttonpressed(_ sender: UIButton) {
        if viewconstraint.constant < 20 {
            UIView.animate(withDuration: 0.2, animations: {
                self.viewconstraint.constant = 0
                self.view.layoutIfNeeded()
                self.menu.isHidden = true
            })
        }
    }
    
    
    @IBAction func Homebuttonpressed(_ sender: UIButton) {
        if viewconstraint.constant > -175 {
            UIView.animate(withDuration: 0.2, animations: {
                self.viewconstraint.constant = -175
                self.view.layoutIfNeeded()
                self.menu.isHidden = false
            })
        }
    }
    

    @IBAction func weatherbuttonpressed(_ sender: UIButton) {
        
        activityindactor.center = self.view.center
        activityindactor.hidesWhenStopped = true
        activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityindactor)
        self.activityindactor.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        let server = Servercalls()
        server.apicall(city: city!, state: state!, voicecall: "Weather")
        print(Servercalls.serverjson)
        
       DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
        
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activityindactor.removeFromSuperview()
        
        print(Servercalls.serverjson)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Weather_ID") as! Weather
        self.present(vc, animated: true, completion: nil)
        
       })
    }
    
    
    
    @IBAction func panguesture(_ sender: UIPanGestureRecognizer) {
      
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if viewconstraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewconstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                        self.menu.isHidden = true
                    })
                }
            }else{ //swipe left
                if viewconstraint.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewconstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }else if sender.state == .ended{
            if viewconstraint.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewconstraint.constant = -175
                    self.view.layoutIfNeeded()
                })
                 self.menu.isHidden = false
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewconstraint.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
        }
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
                if self.city != nil && self.state != nil {
                self.city = self.city!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                print(self.city)
                print(self.state)
                print(self.stringtoserver)
                }
                
            } else {
                // add some more check's if for some reason location manager is nil
            }
        })
    }
    
     func FetchJSON() {
        let server = Servercalls()
        server.apicall(city: city!, state: state!, voicecall: self.stringtoserver!.lowercased())
        print(Servercalls.serverjson)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
        if Servercalls.serverjson["key"].string != nil {
            //self.activityindactor.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityindactor.removeFromSuperview()
            switch (Servercalls.serverjson["key"].string!){
            case "weather":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Weather_ID") as! Weather
                self.present(vc, animated: true, completion: nil)
            case "youtube":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Youtube_ID") as! Youtube
                self.present(vc, animated: true, completion: nil)
            case "google":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Search_ID") as! Search
                self.present(vc, animated: true, completion: nil)
            default: break
            }
        }else{
//            self.activityindactor.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityindactor.removeFromSuperview()
        }
            })
    }
    
    @IBAction func voicebutton(_ sender: UIButton) {
       
        if audioEngine.isRunning {
            audioEngine.stop()
            self.voice_button.setTitle("Make a request!", for: .normal)
            recognitionRequest?.endAudio()
            if (self.stringtoserver != nil){
            self.stringtoserver = self.stringtoserver!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            print(stringtoserver)
            voicequestion = true
                activityindactor.center = self.view.center
                activityindactor.hidesWhenStopped = true
                activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
                self.activityindactor.startAnimating()
                view.addSubview(activityindactor)
                UIApplication.shared.beginIgnoringInteractionEvents()
            //self.activityindactor.startAnimating()
            //UIApplication.shared.beginIgnoringInteractionEvents()
            self.FetchJSON()
            
            }
        } else {
            startRecording()
        }
    }
    
    @IBAction func makealistbutton(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Make_a_list_ID") as! Make_a_list
        self.present(vc, animated: true, completion: nil)
    }
    
    func startRecording() {
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
          
//            let settings = [
//                AVFormatIDKey : kAudioFormatLinearPCM,
//                AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue,
//                AVEncoderBitRateKey: 8000,
//                AVNumberOfChannelsKey : 1,
//                AVSampleRateKey : 8000
//            ] as [String : Any]
            // 4. create the audio recording, and assign ourselves as the delegate
//            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
//            audioRecorder?.delegate = self
//            audioRecorder?.record()
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
             let inputNode = audioEngine.inputNode
            
            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }
            
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                
                var isFinal = false
                
                if result != nil {
                    self.stringtoserver = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            
            do {
                try audioEngine.start()
                self.voice_button.setTitle("Press me again After You Finsh Talking!", for: .normal)
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            
            //5. Changing recording bool to true
            isRecording = true
        }
        catch let error {
            // failed to record!
        }
    }
    
    // Stop recording
    func finishRecording() {
//        audioRecorder?.stop()
//        isRecording = false
//        let url = getAudioFileUrl()
//        
//        do {
//            // AVAudioPlayer setting up with the saved file URL
//            let sound = try AVAudioPlayer(contentsOf: url)
//            self.player = sound
//            
//            // Here conforming to AVAudioPlayerDelegate
//            sound.delegate = self
//            sound.prepareToPlay()
//            sound.play()
//        } catch {
//            print("error loading file")
//            // couldn't load file :(
//        }
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//
//        storageRef.child("ios_voice.amr")
//
    }
    
    // Path for saving/retreiving the audio file
    func getAudioFileUrl() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording.caf")
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

    @IBAction func Signout(_ sender: UIButton) {
        do {
                try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login_ID") as! Login
            self.present(vc, animated: true, completion: nil)
                    } catch {
                        print(error)
                    }
            }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any])
    {
        //recieve messages from watch
        //self.msgLabel.text = message["wTp"]! as? String
        DispatchQueue.main.async
            {
                //request
                self.resuestfromwatch = message["Request"]! as? String
                
                let server = Servercalls()
                server.apicall(city: self.city!, state: self.state!, voicecall: self.resuestfromwatch)
                var sendtowatch: String = ""
                print(Servercalls.serverjson)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
                    
                    if Servercalls.serverjson["key"].string != nil {
                        switch (Servercalls.serverjson["key"].string!){
                        case "weather":
                            
                            //0 key //1 city //2 state //3 condition //4 url //5 rain //6 temp low //7 temp high //8 month/date/year //9 repeat condition
                            
                       sendtowatch = Servercalls.serverjson["key"].string! + "," + Servercalls.serverjson["city"].string! + "," + Servercalls.serverjson["state"].string! + "," + Servercalls.serverjson["results"][0]["condition"].string! + "," +  Servercalls.serverjson["results"][0]["url"].string! + "," + String(Servercalls.serverjson["results"][0]["precip"].double!) + "%" + "," + Servercalls.serverjson["results"][0]["temp_lowf"].string! + "°F" + "," + Servercalls.serverjson["results"][0]["temp_highf"].string! + "°F" + "," + String(Servercalls.serverjson["results"][0]["month"].int!) + "/" + String(Servercalls.serverjson["results"][0]["day"].int!) + "/" + String(Servercalls.serverjson["results"][0]["year"].int!)
                        
                      sendtowatch += "," + Servercalls.serverjson["results"][1]["condition"].string! + "," +  Servercalls.serverjson["results"][1]["url"].string! + "," + String(Servercalls.serverjson["results"][1]["precip"].double!) + "%" + "," + Servercalls.serverjson["results"][1]["temp_lowf"].string! + "°F" + "," + Servercalls.serverjson["results"][1]["temp_highf"].string! + "°F" + "," + String(Servercalls.serverjson["results"][1]["month"].int!) + "/" + String(Servercalls.serverjson["results"][1]["day"].int!) + "/" + String(Servercalls.serverjson["results"][1]["year"].int!)
                            
                            
                     sendtowatch += "," + Servercalls.serverjson["results"][2]["condition"].string! + "," +  Servercalls.serverjson["results"][2]["url"].string! + "," + String(Servercalls.serverjson["results"][2]["precip"].double!) + "%" + "," + Servercalls.serverjson["results"][2]["temp_lowf"].string! + "°F" + "," + Servercalls.serverjson["results"][2]["temp_highf"].string! + "°F" + "," + String(Servercalls.serverjson["results"][2]["month"].int!) + "/" + String(Servercalls.serverjson["results"][2]["day"].int!) + "/" + String(Servercalls.serverjson["results"][2]["year"].int!)
                            
                            
                      sendtowatch +=  "," + Servercalls.serverjson["results"][3]["condition"].string! + "," +  Servercalls.serverjson["results"][3]["url"].string! + "," + String(Servercalls.serverjson["results"][3]["precip"].double!) + "%" + "," + Servercalls.serverjson["results"][3]["temp_lowf"].string! + "°F" + "," + Servercalls.serverjson["results"][3]["temp_highf"].string! + "°F" + "," + String(Servercalls.serverjson["results"][3]["month"].int!) + "/" + String(Servercalls.serverjson["results"][3]["day"].int!) + "/" + String(Servercalls.serverjson["results"][3]["year"].int!)
                            
                            
                    sendtowatch += "," + Servercalls.serverjson["results"][4]["condition"].string! + "," +  Servercalls.serverjson["results"][4]["url"].string! + "," + String(Servercalls.serverjson["results"][4]["precip"].double!) + "%" + "," + Servercalls.serverjson["results"][4]["temp_lowf"].string! + "°F" + "," + Servercalls.serverjson["results"][4]["temp_highf"].string! + "°F" + "," + String(Servercalls.serverjson["results"][4]["month"].int!) + "/" + String(Servercalls.serverjson["results"][4]["day"].int!) + "/" + String(Servercalls.serverjson["results"][4]["year"].int!)
                            
                            
                    sendtowatch += "," + Servercalls.serverjson["results"][5]["condition"].string! + "," +  Servercalls.serverjson["results"][5]["url"].string! + "," + String(Servercalls.serverjson["results"][5]["precip"].double!) + "%" + "," + Servercalls.serverjson["results"][5]["temp_lowf"].string! + "°F" + "," + Servercalls.serverjson["results"][5]["temp_highf"].string! + "°F" + "," + String(Servercalls.serverjson["results"][5]["month"].int!) + "/" + String(Servercalls.serverjson["results"][5]["day"].int!) + "/" + String(Servercalls.serverjson["results"][5]["year"].int!)
                            
                            
                    sendtowatch += "," + Servercalls.serverjson["results"][6]["condition"].string! + "," +  Servercalls.serverjson["results"][6]["url"].string! + "," + String(Servercalls.serverjson["results"][6]["precip"].double!) + "%" + "," + Servercalls.serverjson["results"][6]["temp_lowf"].string! + "°F" + "," + Servercalls.serverjson["results"][6]["temp_highf"].string! + "°F" + "," + String(Servercalls.serverjson["results"][6]["month"].int!) + "/" + String(Servercalls.serverjson["results"][6]["day"].int!) + "/" + String(Servercalls.serverjson["results"][6]["year"].int!)
                            
                        case "youtube":
                            sendtowatch = "youtube"
                            break
                           
                        case "google":
                            
                            // 0 key
                            // 1 title
                            // 2 snippet
                            // 3 url
                            
                       sendtowatch = Servercalls.serverjson["key"].string! + "," +  Servercalls.serverjson["results"][0]["title"].string! + "," + Servercalls.serverjson["results"][0]["snippet"].string! + "," + Servercalls.serverjson["results"][0]["url"].string!
                            
                      sendtowatch += "," + Servercalls.serverjson["results"][1]["title"].string! + "," + Servercalls.serverjson["results"][1]["snippet"].string! + "," +  Servercalls.serverjson["results"][1]["url"].string!
                            
                       sendtowatch += "," + Servercalls.serverjson["results"][2]["title"].string! + "," + Servercalls.serverjson["results"][2]["snippet"].string! + "," +  Servercalls.serverjson["results"][2]["url"].string!
                       
                       sendtowatch += "," + Servercalls.serverjson["results"][3]["title"].string! + "," +  Servercalls.serverjson["results"][3]["snippet"].string! + "," +  Servercalls.serverjson["results"][3]["url"].string!
                            
                       sendtowatch += "," + Servercalls.serverjson["results"][4]["title"].string! + "," +  Servercalls.serverjson["results"][4]["snippet"].string! + "," +  Servercalls.serverjson["results"][4]["url"].string!
                            
                       sendtowatch += "," + Servercalls.serverjson["results"][5]["title"].string! + "," +  Servercalls.serverjson["results"][5]["snippet"].string! + "," +  Servercalls.serverjson["results"][5]["url"].string!
                            
                       sendtowatch += "," + Servercalls.serverjson["results"][6]["title"].string! + "," +  Servercalls.serverjson["results"][6]["snippet"].string! + "," +  Servercalls.serverjson["results"][6]["url"].string!
                    
                       sendtowatch += "," + Servercalls.serverjson["results"][7]["title"].string! + "," +  Servercalls.serverjson["results"][7]["snippet"].string! + "," +  Servercalls.serverjson["results"][7]["url"].string!
                           
                       sendtowatch += "," + Servercalls.serverjson["results"][8]["title"].string! + "," +  Servercalls.serverjson["results"][8]["snippet"].string! + "," +  Servercalls.serverjson["results"][8]["url"].string!
                            
                       sendtowatch += "," + Servercalls.serverjson["results"][9]["title"].string! + "," +  Servercalls.serverjson["results"][9]["snippet"].string! + "," +  Servercalls.serverjson["results"][9]["url"].string!
                            
                        default: sendtowatch = "error"
                        }
                    }else{
                        sendtowatch = "error"
                    }
                    
                      session.sendMessage(["key": sendtowatch], replyHandler: nil, errorHandler: nil)
                })
              
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
        }
