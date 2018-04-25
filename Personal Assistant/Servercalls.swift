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

    static var serverjson = JSON()
    
    func apicall(city: String, state: String, voicecall: String) {
    let urlString = "https://personalassistant-ec554.appspot.com/recognize/" + voicecall + "/" + state + "/" + city
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, reponse, err) in
            sleep(3)
            guard let data = data else { return }
            do {
                
               Servercalls.serverjson = try JSON(data: data)
        } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
}
