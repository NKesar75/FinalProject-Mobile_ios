//
//  News.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/1/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import SwiftyJSON

class News: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var newstable: UITableView!

    struct Newsinfo{
        var Title : String
        var Desc : String
        var image : String
        var URL : String
    }
    
    var newsarray:[Newsinfo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newstable.delegate = self
        newstable.dataSource = self
        pullnews()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return newsarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ncell = newstable.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsTableViewCell
        
        ncell.titleofnews.text = newsarray[indexPath.row].Title
        ncell.descofnews.text =  newsarray[indexPath.row].Desc
        ncell.urlofnews.text =  newsarray[indexPath.row].URL
        let imageUrl:URL = URL(string: newsarray[indexPath.row].image)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        ncell.imageview.image = UIImage(data: imageData as Data)
        ncell.imageview.contentMode = UIViewContentMode.scaleAspectFit
        
        return ncell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let url = URL(string: newsarray[indexPath.row].URL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func pullnews(){
        
        if newsselctortypeViewController.newsjson["status"].string != nil && newsselctortypeViewController.newsjson["status"].string == "ok" {
            newsarray.removeAll()
            var index:Int = 0
            while true {
                
                if  newsselctortypeViewController.newsjson["articles"][index]["title"].string != nil && newsselctortypeViewController.newsjson["articles"][index]["description"].string != nil && newsselctortypeViewController.newsjson["articles"][index]["urlToImage"].string != nil && newsselctortypeViewController.newsjson["articles"][index]["url"].string != nil {
                    
                      newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][index]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][index]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][index]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][index]["url"].string!))
                }else{
                    break
                }
                index += 1
            }
        }
        newstable.reloadData()
        
    }
}
