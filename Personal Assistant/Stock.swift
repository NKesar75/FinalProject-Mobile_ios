//
//  Stock.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/1/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import SwiftyJSON

class Stock: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var newsjson = JSON()
    @IBOutlet weak var stockstable: UITableView!
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    struct stockstruct{
        var nameofcompany : String
        var priceofstock : String
        var sizeofstock : String
        var imagename: String
    }
    
    var stocks:[stockstruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        stockstable.delegate = self
        stockstable.dataSource = self
        self.pullstock()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activityindactor.center = self.view.center
        activityindactor.hidesWhenStopped = true
        activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityindactor.color = UIColor.black
        view.addSubview(activityindactor)
        self.activityindactor.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    
    
    func pullstock(){
       let urlString = "https://api.iextrading.com/1.0/tops/last?symbols=aapl,bac,ccf,cvx,fb,f,hmc,mcd,msft,frsh,pep,sonc,sne,s,tgt,tm,vz,wmt,dis,wen"
        
        
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
            print(self.newsjson)
            if self.newsjson[0]["symbol"].string != nil {
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityindactor.removeFromSuperview()
                self.FetchPreviousCall()
                
            }else{
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityindactor.removeFromSuperview()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let scell = stockstable.dequeueReusableCell(withIdentifier: "Stockcell") as! StockCell
        
        scell.nameofcompany.text = stocks[indexPath.row].nameofcompany
        scell.Priceofstock.text = stocks[indexPath.row].priceofstock
        scell.Sizeofstock.text = stocks[indexPath.row].sizeofstock
        scell.imageforcompany.image = UIImage(named: stocks[indexPath.row].imagename) as UIImage?
        scell.imageforcompany.contentMode = UIViewContentMode.scaleAspectFit
        
        return scell
    }
    
    func FetchPreviousCall(){
        if self.newsjson != nil {
            stocks.removeAll()
            
            var index:Int = 0
            while true {
                if self.newsjson[][index]["symbol"].string != nil && self.newsjson[index]["price"].string != nil && self.newsjson[index]["size"].string != nil {
                    var nameofcompany = ""
                    var imageofcompany = ""
                    
                    switch (self.newsjson[index]["symbol"].string!){
                    case "AAPL":
                        nameofcompany = "Apple Inc."
                        imageofcompany = "Apple"
                    case "FB":
                        nameofcompany = "Facebook, Inc."
                        imageofcompany = "Facebook"
                    case "MSFT":
                        nameofcompany = "Microsoft Corporation"
                        imageofcompany = "Microsoft"
                    case "SNE":
                        nameofcompany = "Sony Corp"
                        imageofcompany = "Sony"
                        
                    case "HMC":
                        nameofcompany = "Honda Motor Co Ltd"
                        imageofcompany = "Honda"
                    case "TM":
                        nameofcompany = "Toyota Motor Corp"
                        imageofcompany = "Toyota"
                    case "DIS":
                        nameofcompany = " Walt Disney Co"
                        imageofcompany = "Walt"
                    case "BAC":
                        nameofcompany = "Bank of America Corp"
                        imageofcompany = "Bank"
                        
                    case "CCF":
                        nameofcompany = "Chase Corporation"
                        imageofcompany = "Chase"
                    case "SONC":
                        nameofcompany = "Sonic Corporation"
                        imageofcompany = "Sonic"
                    case "MCD":
                        nameofcompany = "McDonald's Corporation"
                        imageofcompany = "McDonald"
                    case "WEN":
                        nameofcompany = "Wendys Co"
                        imageofcompany = "Wendys"
                        
                    case "WMT":
                        nameofcompany = "Walmart Inc"
                        imageofcompany = "Walmart"
                    case "TGT":
                        nameofcompany = "Target Corporation"
                        imageofcompany = "Target"
                    case "PEP":
                        nameofcompany = "PepsiCo Inc."
                        imageofcompany = "PepsiCo"
                    case "FRSH":
                        nameofcompany = "Papa Murphy's Holdings Inc"
                        imageofcompany = "Papa"
               
                    case "VZ":
                        nameofcompany = "Verizon Communications Inc."
                        imageofcompany = "Verizon"
                    case "S":
                        nameofcompany = "Sprint Corp"
                        imageofcompany = "Sprint"
                    case "CVX":
                        nameofcompany = "Chevron Corporation"
                        imageofcompany = "Chevron"
                    case "F":
                        nameofcompany = "Ford Motor Company"
                        imageofcompany = "Ford"

                    default:
                        break
                    }
                    
                    
                    
                    stocks.append(stockstruct(nameofcompany: nameofcompany, priceofstock: String(self.newsjson[index]["price"].double!), sizeofstock: String(self.newsjson[index]["size"].int!), imagename: imageofcompany))
                }else{
                    break
                }
                index += 1
            }
        }
        print(stocks)
        print(stocks.count)
        stockstable.reloadData()
    
    }
    
}
