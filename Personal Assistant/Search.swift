//
//  Search.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/24/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class Search: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    struct googlesearchinfo{
        var title : String
        var snippet : String
        var url : String
    }
    
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var SearchText: UITextField!
    @IBOutlet weak var googlesearchtableview: UITableView!
    let locationManager:CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var city: String?
    var state: String?
    
    var googlesearches:[googlesearchinfo] = []
    
    
    var serverjson = JSON()
    
    static var titleofsearch = ""
    static var urlofsearch = ""
    static var typeforfirebase = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        googlesearchtableview.delegate = self
        googlesearchtableview.dataSource = self
        self.FetchPreviousCall()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(Search.longPress(longPressGestureRecognizer:)))
        self.googlesearchtableview.addGestureRecognizer(longPressRecognizer)
    }
    
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: googlesearchtableview)
            if let indexPath = googlesearchtableview.indexPathForRow(at: touchPoint) {
                print("touchpoint " ,touchPoint)
                if googlesearches[indexPath.row] != nil {
                    Search.titleofsearch = googlesearches[indexPath.row].title
                    Search.urlofsearch = googlesearches[indexPath.row].url
                    Search.typeforfirebase = "Google"
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Searchpopup_ID") as! Searchpopup
                    self.addChildViewController(popOverVC)
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParentViewController: self)
                }
            }
        }
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
    
    func searchmanual(){
        view.endEditing(true)
        if SearchText.text != "" && SearchText.text != " "{
            activityindactor.center = self.view.center
            
            activityindactor.hidesWhenStopped = true
            activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            
            view.addSubview(activityindactor)
            self.activityindactor.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            var servermetod = "Search for " + SearchText.text!
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
                if self.serverjson["key"].string != nil && self.serverjson["key"] == "google" {
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityindactor.removeFromSuperview()
                    self.FetchPreviousCall()
                    
                }else{
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityindactor.removeFromSuperview()
                }
            })
        }
    }
    
    @IBAction func searchtextfeildpressed(_ sender: Any) {
        searchmanual()
    }
    
    
    @IBAction func searchbuttonpressed(_ sender: UIButton) {
        searchmanual()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: googlesearches[indexPath.row].url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googlesearches.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = googlesearchtableview.dequeueReusableCell(withIdentifier: "customCell") as! CustomCellTableViewCell
        
        cell.customcelltitle.text = googlesearches[indexPath.row].title
        cell.customcellsnippet.text = googlesearches[indexPath.row].snippet
        cell.customcellurl.text = googlesearches[indexPath.row].url
        
        return cell
    }
    
    func FetchPreviousCall(){
        if self.serverjson["key"].string != nil && self.serverjson["key"] == "google" {
            googlesearches.removeAll()
            
            var index:Int = 0
            while true {
                if self.serverjson["results"][index]["title"].string != nil && self.serverjson["results"][index]["snippet"].string != nil && self.serverjson["results"][index]["url"].string != nil {
                    
                    googlesearches.append(googlesearchinfo(title: self.serverjson["results"][index]["title"].string!, snippet: self.serverjson["results"][index]["snippet"].string!, url: self.serverjson["results"][index]["url"].string!))
                }else{
                    break
                }
                index += 1
            }
        }
        googlesearchtableview.reloadData()
    }
    
}
