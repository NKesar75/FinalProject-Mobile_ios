//
//  Stock.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/1/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import SwiftyJSON

class Stock: UIViewController{//}, UITableViewDataSource, UITableViewDelegate  {
    
    var newsjson = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    func pullstock(){
       let urlString = "https://api.iextrading.com/1.0/tops/last?symbols=aapl,fb,msft,sne,hmc,tm,dis,bac,ccf,sonc,mcd,wen,wmt,tgt,pep,frsh,dal,vz,s,cvx,f"
        
        
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
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
}
