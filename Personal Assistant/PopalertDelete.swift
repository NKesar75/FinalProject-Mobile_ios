//
//  PopalertDelete.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/10/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase
class PopalertDelete: UIViewController {

    @IBOutlet weak var filenamelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        filenamelabel.text = Make_a_list.nameoflist
        self.showAnimate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Deletebutton(_ sender: Any) {
        if filenamelabel.text != "No File Selected"{
            let userID = Auth.auth().currentUser?.uid
            let ref: DatabaseReference! = Database.database().reference().child("users").child(userID!).child("list").child(filenamelabel.text!)
            print(filenamelabel.text)
            ref.removeValue()
            let storage = Storage.storage()
            let storageRef = storage.reference().child("text-files").child(userID!).child(filenamelabel.text! + ".txt")
            storageRef.delete { error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error)
                } else {
                    // File deleted successfully
                }
            }
            //self.view.removeFromSuperview()
            self.removeAnimate()
        }
    }
    
    @IBAction func Cancelbutton(_ sender: Any) {
        //self.view.removeFromSuperview()
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    @IBAction func savebuttonpressed(_ sender: Any) {
        if filenamelabel.text != "No File Selected"{
            var listtitle = Make_a_list.nameoflist
            var listlinc = Make_a_list.nameoftext
            
            listtitle = listtitle.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "$", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "[", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "]", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "#", with: " ", options: .literal, range: nil)
            listtitle = listtitle.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
            
            listlinc = listlinc.replacingOccurrences(of: ".", with: " ", options: .literal, range: nil)
            listlinc = listlinc.replacingOccurrences(of: "$", with: " ", options: .literal, range: nil)
            listlinc = listlinc.replacingOccurrences(of: "[", with: " ", options: .literal, range: nil)
            listlinc = listlinc.replacingOccurrences(of: "]", with: " ", options: .literal, range: nil)
            listlinc = listlinc.replacingOccurrences(of: "#", with: " ", options: .literal, range: nil)
            listlinc = listlinc.replacingOccurrences(of: "/", with: " ", options: .literal, range: nil)
            
            let temp: Remberfirebasehelperclass = Remberfirebasehelperclass()
            temp.pushtofirebase(link: listtitle + "-,-" + listlinc, type: "List")
            
            self.removeAnimate()
        }
        
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
