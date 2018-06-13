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
    var newsjson = JSON()
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
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(News.longPress(longPressGestureRecognizer:)))
        self.newstable.addGestureRecognizer(longPressRecognizer)
        
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
    
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: newstable)
            if let indexPath = newstable.indexPathForRow(at: touchPoint) {
                print("touchpoint " ,touchPoint)
                if newsarray[indexPath.row] != nil {
                    Search.titleofsearch = newsarray[indexPath.row].Title
                    Search.urlofsearch = newsarray[indexPath.row].URL
                    Search.typeforfirebase = "News"
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Searchpopup_ID") as! Searchpopup
                    self.addChildViewController(popOverVC)
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParentViewController: self)
                }
            }
        }
    }
    
    func pullnews(){
        
        if self.newsjson["status"].string != nil && self.newsjson["status"].string == "ok" {
            newsarray.removeAll()
            var index:Int = 0
            while true {
                
                if  self.newsjson["articles"][index]["title"].string != nil && self.newsjson["articles"][index]["description"].string != nil && self.newsjson["articles"][index]["urlToImage"].string != nil && self.newsjson["articles"][index]["url"].string != nil {
                    
                    newsarray.append(Newsinfo(Title: self.newsjson["articles"][index]["title"].string!, Desc: self.newsjson["articles"][index]["description"].string!, image: self.newsjson["articles"][index]["urlToImage"].string!, URL: self.newsjson["articles"][index]["url"].string!))
                }else{
                    break
                }
                index += 1
            }
        }
        print(newsarray)
        newstable.reloadData()
    }
}
