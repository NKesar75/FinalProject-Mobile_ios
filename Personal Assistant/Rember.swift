//
//  Rember.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/30/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase

class Rember: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct listitems{
        var link:String
        var type:String
    }
    
    var listtitles:[listitems] = []
    
    @IBOutlet weak var rembertable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rembertable.delegate = self
        rembertable.dataSource = self
        // Do any additional setup after loading the view.
        
        
        let userID = Auth.auth().currentUser?.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID!).child("remeb")
        listtitles.removeAll()
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let key = snapshot.key
            let value = snapshot.value
            //print("key = \(key)  value = \(value!)")
            // print(key)
            self.listtitles.append(listitems(link: key , type: String(describing: value!)))
            
            print(snapshot)
            self.rembertable.reloadData()
        })
        
        // Listen for deleted comments in the Firebase database
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
        
            self.listtitles.remove(at: self.listtitles.index(where: { $0.link == snapshot.key })!)
            self.rembertable.reloadData()
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return listtitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Lcell = rembertable.dequeueReusableCell(withIdentifier: "RemberCell") as! UITableViewCell

            Lcell.textLabel?.text = self.listtitles[indexPath.row].link
            Lcell.detailTextLabel?.text = self.listtitles[indexPath.row].type
        switch self.listtitles[indexPath.row].type {
        case "Youtube":
             Lcell.textLabel?.textColor = UIColor.red
        case "Google":
             Lcell.textLabel?.textColor = UIColor.green
        case "List":
            Lcell.textLabel?.textColor = UIColor.white
        default:
            Lcell.textLabel?.textColor = UIColor.black
        }
        
        
        return Lcell
    }


}
