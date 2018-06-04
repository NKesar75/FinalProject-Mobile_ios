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
    var images:[String] = ["Apple", "Business", "Bitcoin", "Tech", "Wall Street"]
    var titles:[String] = ["Apple", "Business", "Bitcoin", "TechCrunch", "Wall Street"]
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
   static var newsjson = JSON()
    
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ncell = newstypeselctortable.dequeueReusableCell(withIdentifier: "newstypecell") as! newstypeselctortable
        
        ncell.typelabel.text = titles[indexPath.row]
        let imagey = UIImage(named: images[indexPath.row]) as UIImage?
        ncell.newtypeimage.image = imagey
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
        case "Apple":
              urlString =  "https://newsapi.org/v2/everything?q=apple&from=2018-06-03&to=2018-06-03&sortBy=popularity&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Bitcoin":
             urlString =  "https://newsapi.org/v2/everything?q=bitcoin&sortBy=publishedAt&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Business":
             urlString =  "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "TechCrunch":
             urlString =  "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        case "Wall Street":
             urlString =  "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        default:
             urlString =  "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=388f3a0e55d54bcbb705b8a244b8f380"
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, reponse, err) in
            guard let data = data else { return }
            do {
                
                newsselctortypeViewController.newsjson = try JSON(data: data)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            //print(self.newsjson)
            }.resume()
        
         DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "News_ID") as! News
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityindactor.removeFromSuperview()
        self.present(vc, animated: true, completion: nil)
        })
    }
    

}
