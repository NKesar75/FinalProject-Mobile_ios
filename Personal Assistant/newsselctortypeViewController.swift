//
//  newsselctortypeViewController.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/4/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import SwiftyJSON

class newsselctortypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var newstypeselctortable: UITableView!
    var titles:[String] = ["ABC News", "Apple", "BBC News", "BBC Sports", "Bitcoin", "Bleacher Reports", "Bloomberg", "Breitbart", "Business", "Business Insider", "Buzz Feed", "CBS News", "CNN", "Daily Mail", "Entertainment Week", "ESPN", "Financial Times", "Four Four Two", "Fox News", "Fox Sports", "Google News", "Hacker News", "IGN", "Medical News", "Metro", "MSNBC", "MTV", "National Geographics", "National Review", "NBC News", "New Scientist",  "News 24", "NFL News", "NHL News", "Reddit", "Talk Sports", "TechCrunch", "The New York Times", "USA Today", "Vice News", "Wall Street", "Washington"]
    
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    var newsjson = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newstypeselctortable.delegate = self
        newstypeselctortable.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ncell = newstypeselctortable.dequeueReusableCell(withIdentifier: "newstypecell") as! newstypeselctortable
        
        ncell.typelabel.text = titles[indexPath.row]
        ncell.newtypeimage.image = UIImage(named: titles[indexPath.row]) as UIImage?
        ncell.newtypeimage.contentMode = UIViewContentMode.scaleAspectFit
        
        return ncell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let typeofnews = titles[indexPath.row]
        
        activityindactor.center = self.view.center
        activityindactor.hidesWhenStopped = true
        activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityindactor.color = UIColor.black
        view.addSubview(activityindactor)
        self.activityindactor.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var urlString = ""
        switch  typeofnews {
        
        case "ABC News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=abc-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Apple":
             urlString =  "https://newsapi.org/v2/everything?q=apple&from=2018-06-03&to=2018-06-03&sortBy=popularity&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "BBC News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "BBC Sports":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=bbc-sport&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Bitcoin":
             urlString =  "https://newsapi.org/v2/everything?q=bitcoin&sortBy=publishedAt&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Bleacher Reports":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=bleacher-report&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Bloomberg":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=bloomberg&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Breitbart":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=breitbart-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Business":
             urlString =  "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Business Insider":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=business-insider&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Buzz Feed":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=buzzfeed&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "CBS News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=cbs-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "CNN":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=cnn&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Daily Mail":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=daily-mail&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Entertainment Week":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=entertainment-weekly&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "ESPN":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=espn&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Financial Times":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=financial-times&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Four Four Two":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=four-four-two&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Fox News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=fox-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Fox Sports":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=fox-sports&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Google News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=google-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Hacker News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=hacker-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "IGN":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=ign&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Medical News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=medical-news-today&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Metro":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=metro&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "MSNBC":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=msnbc&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case  "MTV":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=mtv-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "National Geographics":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=national-geographic&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "National Review":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=national-review&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "NBC News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=nbc-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "New Scientist":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=new-scientist&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "News 24":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=news24&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "NFL News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=nfl-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "NHL News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=nhl-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Reddit":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=reddit-r-all&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Talk Sports":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=talksport&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "TechCrunch":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "The New York Times":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=the-new-york-times&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "USA Today":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=usa-today&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Vice News":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=vice-news&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Wall Street":
             urlString =  "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Washington":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=the-washington-times&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        default:
             urlString =  "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, reponse, err) in
            guard let data = data else { return }
            do {
                
                self.newsjson = try JSON(data: data)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
                
            }
            //print(self.newsjson)
            }.resume()

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
        
        UIApplication.shared.endIgnoringInteractionEvents()
        self.activityindactor.removeFromSuperview()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "News_ID") as! News
        vc.newsjson = self.newsjson
        self.present(vc, animated: true, completion: nil)
            
        })
    }
}
