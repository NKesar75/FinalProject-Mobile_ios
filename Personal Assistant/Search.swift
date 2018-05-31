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
    
    static var titleofsearch = ""
    static var urlofsearch = ""
    
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
    
    @IBAction func searchbuttonpressed(_ sender: UIButton) {
        if SearchText.text != "" && SearchText.text != " "{
            activityindactor.center = self.view.center
            //activityindactor.center = googlesearchtableview.center
            activityindactor.hidesWhenStopped = true
            activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            //activityindactor.color = UIColor.black
            view.addSubview(activityindactor)
            self.activityindactor.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            let server = Servercalls()
            var servermetod = "Search for " + SearchText.text!
            servermetod = servermetod.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            server.apicall(city: city!, state: state!, voicecall: servermetod)
            print(Servercalls.serverjson)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityindactor.removeFromSuperview()
                self.FetchPreviousCall()
            })
        }
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
        if Servercalls.serverjson["key"].string != nil && Servercalls.serverjson["key"] == "google" {
            googlesearches.removeAll()
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][0]["title"].string!, snippet: Servercalls.serverjson["results"][0]["snippet"].string!, url: Servercalls.serverjson["results"][0]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][1]["title"].string!, snippet: Servercalls.serverjson["results"][1]["snippet"].string!, url: Servercalls.serverjson["results"][1]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][2]["title"].string!, snippet: Servercalls.serverjson["results"][2]["snippet"].string!, url: Servercalls.serverjson["results"][2]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][3]["title"].string!, snippet: Servercalls.serverjson["results"][3]["snippet"].string!, url: Servercalls.serverjson["results"][3]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][4]["title"].string!, snippet: Servercalls.serverjson["results"][4]["snippet"].string!, url: Servercalls.serverjson["results"][4]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][5]["title"].string!, snippet: Servercalls.serverjson["results"][5]["snippet"].string!, url: Servercalls.serverjson["results"][5]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][6]["title"].string!, snippet: Servercalls.serverjson["results"][6]["snippet"].string!, url: Servercalls.serverjson["results"][6]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][7]["title"].string!, snippet: Servercalls.serverjson["results"][7]["snippet"].string!, url: Servercalls.serverjson["results"][7]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][8]["title"].string!, snippet: Servercalls.serverjson["results"][8]["snippet"].string!, url: Servercalls.serverjson["results"][8]["url"].string!))
            googlesearches.append(googlesearchinfo(title: Servercalls.serverjson["results"][9]["title"].string!, snippet: Servercalls.serverjson["results"][9]["snippet"].string!, url: Servercalls.serverjson["results"][9]["url"].string!))
        }
        googlesearchtableview.reloadData()
    }
    
}
