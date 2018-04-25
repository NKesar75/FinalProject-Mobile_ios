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
class HomePage: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, SFSpeechRecognizerDelegate{

    @IBOutlet weak var menubutton: UIButton!
    @IBOutlet weak var ViewConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var sideview: UIView!
    
    @IBOutlet weak var voice_button: UIButton!
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
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var Locationlabel: UILabel!
    @IBOutlet weak var Humidity: UILabel!
    @IBOutlet weak var rainlabel: UILabel!
    @IBOutlet weak var forcastlabel: UILabel!
    @IBOutlet weak var templabel: UILabel!
    

    var stringtoserver: String?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        
       blurView.layer.cornerRadius = 15
       sideview.layer.shadowColor = UIColor.black.cgColor
       sideview.layer.shadowOpacity = 0.8
       sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        ViewConstarint.constant = -175
        self.menubutton.isHidden = false
        stringtoserver = "text_weather"
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
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        voicequestion = false
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
                print(self.stringtoserver)
                    self.FetchJSON()
                
            } else {
                // add some more check's if for some reason location manager is nil
            }
            
            
        })

    }
    
    
     func FetchJSON() {
        let server = Servercalls()
        server.apicall(city: city!, state: state!, voicecall: self.stringtoserver!)
        print(Servercalls.serverjson)
        if Servercalls.serverjson["key"].string != nil {
            switch (Servercalls.serverjson["key"].string!){
            case "weather":
                if voicequestion == false{
                    self.Locationlabel.text = Servercalls.serverjson["city"].string! + ", " + Servercalls.serverjson["state"].string!
                    self.Humidity.text = "Humidity: " + Servercalls.serverjson["humidity"].string!
                    self.rainlabel.text = "Rain: " + String(Servercalls.serverjson["precip"].double!) + "%"
                    self.forcastlabel.text = "Forcast: " + Servercalls.serverjson["condition"].string!
                    self.templabel.text = String(Servercalls.serverjson["tempf"].double!) + "°F"
                    let imageUrl:URL = URL(string: Servercalls.serverjson["url"].string!)!
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                    self.imageview.image = UIImage(data: imageData as Data)
                    self.imageview.contentMode = UIViewContentMode.scaleAspectFit
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Weather_ID") as! Weather
                    self.present(vc, animated: true, completion: nil)
                }
            case "youtube":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Youtube_ID") as! Youtube
                self.present(vc, animated: true, completion: nil)
            case "google":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Search_ID") as! Search
                self.present(vc, animated: true, completion: nil)
            default: break
            }
        }
        
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
       
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            self.stringtoserver = self.stringtoserver!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            self.stringtoserver = self.stringtoserver!.replacingOccurrences(of: "\'", with: "", options: .literal, range: nil)
            print(stringtoserver)
            voicequestion = true
            FetchJSON()
            
        } else {
            startRecording()
        }
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
}
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
