//
//  Listdata.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase

class Listdata: UIViewController {

    @IBOutlet weak var listcontent: UITextView!
    @IBOutlet weak var listnamelabel: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelbuttonpressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Make_a_list_ID") as! Make_a_list
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func savebuttonpressed(_ sender: UIButton) {
        do {
                // create the destination url for the text file to be saved
                var filename : String = ""
                if listnamelabel.text != nil{
                    filename = listnamelabel.text! + ".txt"
                }else{
                    let dateFormatter : DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = Date()
                    var dateString = dateFormatter.string(from: date)
                    dateString = dateString.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
                    filename = dateString + ".txt"
                }
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let docsDirect = paths[0]
                let fileURL = docsDirect.appendingPathComponent(filename)
                // define the string/text to be saved
                 let text = listcontent.text!
                 try text.write(to: fileURL, atomically: false, encoding: .utf8)
                print("saving was successful")
                print(filename)
                print(text)
                print(fileURL)
            
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let fileref = storageRef.child(filename)
                    fileref.putFile(from: fileURL)
            
                    var ref: DatabaseReference! = Database.database().reference()
                    let userID = Auth.auth().currentUser?.uid
                    ref.child(userID!).child("Lists").child("list1").setValue(fileURL.absoluteString)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Make_a_list_ID") as! Make_a_list
                    self.present(vc, animated: true, completion: nil)
            
            } catch {
                print("error:", error)
            }
    }
    


}
