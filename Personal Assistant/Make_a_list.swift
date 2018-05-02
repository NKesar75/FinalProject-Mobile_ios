//
//  Make_a_list.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase

class Make_a_list: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tablelist: UITableView!
    var listtitles:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tablelist.delegate = self
        tablelist.dataSource = self
        self.pullfromfirebase()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listtitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Lcell = tablelist.dequeueReusableCell(withIdentifier: "listcell") as! UITableViewCell
        
        Lcell.textLabel?.text = self.listtitles[indexPath.row]
        
        return Lcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listtitles[indexPath.row] == "New List" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Listdata_ID") as! Listdata
            self.present(vc, animated: true, completion: nil)
        }else{
            
        }
    }
    
    func pullfromfirebase(){
        
        listtitles.append("New List")
        
    }
    

}
