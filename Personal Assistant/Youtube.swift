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

class Youtube: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, SFSpeechRecognizerDelegate {

    @IBOutlet weak var Sideview: UIView!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var Blur_View: UIVisualEffectView!
    @IBOutlet weak var View_Constarint: NSLayoutConstraint!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Blur_View.layer.cornerRadius = 15
        Sideview.layer.shadowColor = UIColor.black.cgColor
        Sideview.layer.shadowOpacity = 0.8
        Sideview.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        View_Constarint.constant = -175
        self.menu.isHidden = false
        
        setvideo(videoid: "QrVjFfP4pak")
        
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
    
    
    @IBAction func voicebuttonpressed(_ sender: UIButton) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            HomePage.stringtoserver = HomePage.stringtoserver!.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            HomePage.stringtoserver = HomePage.stringtoserver!.replacingOccurrences(of: "\'", with: "", options: .literal, range: nil)
            print(HomePage.stringtoserver)
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
    HomePage.stringtoserver = result?.bestTranscription.formattedString
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
    
    
    struct Youtube: Decodable {
        let key: String
        let id: String
        let Descritpiton: String
        
        // swift 4.0
        private enum CodingKeys: String, CodingKey {
            case key = "key"
            case id = "tempf"
            case Descritpiton = "tempc"
        }
    }
    
    
    fileprivate func FetchJSON() {
        var temp = self.state! + "/" + self.city!
        let urlString = "https://personalassistant-ec554.appspot.com/recognize/play_" + HomePage.stringtoserver! + "/" + temp
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    // Swift 4.1
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let Cyoutube = try JSONDecoder().decode(Youtube.self, from: data)
                   
                    
                    
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
    }
        
    }
    



