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
    
    
    struct listitems{
        var key:String
        var value:String
    }
    
    @IBOutlet weak var tablelist: UITableView!
    
    var listtitles:[listitems] = []
    
    static var nameoftext = "New List"
    static var nameoflist = ""
    
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
        
        Lcell.textLabel?.text = self.listtitles[indexPath.row].key
        
        return Lcell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listtitles[indexPath.row].key == "New List" {
            Make_a_list.nameoflist = ""
            Make_a_list.nameoftext = "New List"
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Listdata_ID") as! Listdata
            self.present(vc, animated: true, completion: nil)
        }else{
            Make_a_list.nameoflist = listtitles[indexPath.row].key
            Make_a_list.nameoftext = listtitles[indexPath.row].value
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Listdata_ID") as! Listdata
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func pullfromfirebase(){
        listtitles.append(listitems(key: "New List", value: "null"))
        let userID = Auth.auth().currentUser?.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID!).child("list")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                //print("key = \(key)  value = \(value!)")
               // print(key)
                self.listtitles.append(listitems(key: String(describing: key), value: String(describing: value!)))
            }
            self.tablelist.reloadData()
        })
    }
}
