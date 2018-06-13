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
    
    static var titleofrember = ""
    static var typeurlofrember = ""
    
    
    @IBOutlet weak var rembertable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rembertable.delegate = self
        rembertable.dataSource = self
        // Do any additional setup after loading the view.
        HomePage.diditcomefromrember = true
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(Rember.longPress(longPressGestureRecognizer:)))
        self.rembertable.addGestureRecognizer(longPressRecognizer)
        
        let userID = Auth.auth().currentUser?.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID!).child("remeb")
        listtitles.removeAll()
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            let key = snapshot.key
            let value = snapshot.value
            self.listtitles.append(listitems(link: key , type: String(describing: value!)))
            self.rembertable.reloadData()
        })
        
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            
            self.listtitles.remove(at: self.listtitles.index(where: { $0.link == snapshot.key })!)
            self.rembertable.reloadData()
        })
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
        
        let colorcode = self.listtitles[indexPath.row].type.split(separator: ",")
        switch colorcode[0] {
        case "Youtube":
            Lcell.textLabel?.textColor = UIColor.red
        case "Google":
            Lcell.textLabel?.textColor = UIColor.green
        case "List":
            Lcell.textLabel?.textColor = UIColor.white
        case "News":
            Lcell.textLabel?.textColor = UIColor.purple
        default:
            Lcell.textLabel?.textColor = UIColor.black
        }
        
        
        return Lcell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var typeofcontent = listtitles[indexPath.row].type.split(separator: ",")
        if typeofcontent != nil {
            Rember.titleofrember = listtitles[indexPath.row].link
            Rember.typeurlofrember = listtitles[indexPath.row].type
            
            switch typeofcontent[0] {
            case "Youtube":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemberWeb_ID") as! RemberWebview
                self.present(vc, animated: true, completion: nil)
                
            case "Google":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemberWeb_ID") as! RemberWebview
                self.present(vc, animated: true, completion: nil)
                
            case "List":
                Make_a_list.nameoftext = String(typeofcontent[1])
                Make_a_list.nameoflist = Rember.titleofrember
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Listdata_ID") as! Listdata
                self.present(vc, animated: true, completion: nil)
            case "News":
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "RemberWeb_ID") as! RemberWebview
                self.present(vc, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: rembertable)
            if let indexPath = rembertable.indexPathForRow(at: touchPoint) {
                if listtitles[indexPath.row] != nil {
                    Rember.titleofrember = listtitles[indexPath.row].link
                    Rember.typeurlofrember = listtitles[indexPath.row].type
                    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Remberpopup_ID") as! Remberpopup
                    self.addChildViewController(popOverVC)
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    popOverVC.didMove(toParentViewController: self)
                }
            }
        }
    }
    
}
