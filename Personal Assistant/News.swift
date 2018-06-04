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
            newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][0]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][0]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][0]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][0]["url"].string!))
            
             newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][1]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][1]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][1]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][1]["url"].string!))
            
             newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][2]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][2]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][2]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][2]["url"].string!))
            
             newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][3]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][3]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][3]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][3]["url"].string!))
            
             newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][4]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][4]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][4]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][4]["url"].string!))
            
             newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][5]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][5]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][5]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][5]["url"].string!))
            
             newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][6]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][6]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][6]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][6]["url"].string!))
            
             newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][7]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][7]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][7]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][7]["url"].string!))
            
            newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][8]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][8]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][8]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][8]["url"].string!))

            newsarray.append(Newsinfo(Title: newsselctortypeViewController.newsjson["articles"][9]["title"].string!, Desc: newsselctortypeViewController.newsjson["articles"][9]["description"].string!, image: newsselctortypeViewController.newsjson["articles"][9]["urlToImage"].string!, URL: newsselctortypeViewController.newsjson["articles"][9]["url"].string!))
        }
        print("newsarray",newsarray)
        newstable.reloadData()
        
    }
}
