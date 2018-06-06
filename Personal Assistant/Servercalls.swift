//
//  Servercalls.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/24/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Servercalls: UIViewController {

    var serverjson = JSON()
    
    func apicall(city: String, state: String, voicecall: String) {
        print(voicecall)
//    let urlString = "https://personalassistant-ec554.appspot.com/recognize/" + voicecall + "/" + state + "/" + city
//        guard let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { (data, reponse, err) in
//            guard let data = data else { return }
//            do {
//
//                self.serverjson = try JSON(data: data)
//        } catch let jsonErr {
//                print("Error serializing json:", jsonErr)
//            }
//
//            }.resume()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
//            if self.serverjson["key"].string != nil {
//                print("weather", self.serverjson)
//                switch (self.serverjson["key"].string!){
//                case "weather":
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Weather_ID") as! Weather
//                    vc.serverjson = self.serverjson
//                    self.present(vc, animated: true, completion: nil)
//                case "youtube":
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Youtube_ID") as! Youtube
//                     vc.serverjson = self.serverjson
//                    self.present(vc, animated: true, completion: nil)
//                case "google":
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Search_ID") as! Search
//                     vc.serverjson = self.serverjson
//                    self.present(vc, animated: true, completion: nil)
//                default:
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage_ID") as! HomePage
//                self.present(vc, animated: true, completion: nil)
//                }
//            }else{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage_ID") as! HomePage
//                self.present(vc, animated: true, completion: nil)
//            }
//        })
//
        
        
    }
}
