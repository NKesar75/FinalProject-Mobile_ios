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
    
    var activityindactor:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Make_a_list.nameoftext != "New List" && Make_a_list.nameoftext != ""{
            activityindactor.center = self.view.center
            activityindactor.hidesWhenStopped = true
            activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityindactor.color = UIColor.black
            view.addSubview(activityindactor)
            self.activityindactor.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
                // get a storage reference from the URL
                listnamelabel.text = Make_a_list.nameoflist
                let storage = Storage.storage()
                print(Make_a_list.nameoftext)
                let storageRef = storage.reference(forURL: Make_a_list.nameoftext)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)

           
            storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                   self.listcontent.text = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                }
            }
            UIApplication.shared.endIgnoringInteractionEvents()
            self.activityindactor.removeFromSuperview()
        
            // define the string/text to be saved
           
        }//else do nothing
    
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelbuttonpressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Make_a_list_ID") as! Make_a_list
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func savebuttonpressed(_ sender: UIButton) {
        activityindactor.center = self.view.center
        activityindactor.hidesWhenStopped = true
        activityindactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityindactor.color = UIColor.black
        view.addSubview(activityindactor)
        self.activityindactor.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        do {
                // create the destination url for the text file to be saved
                var filename : String = ""
                if listnamelabel.text?.isEmpty != true{
                    filename = listnamelabel.text!
                }else{
                    let dateFormatter : DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
                    let date = Date()
                    var dateString = dateFormatter.string(from: date)
//                    dateString = dateString.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
//                    dateString = dateString.replacingOccurrences(of: ":", with: "-", options: .literal, range: nil)
                    filename = dateString
                }
                let nameoffile = filename
                filename += ".txt"
            
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let docsDirect = paths[0]
                let fileURL = docsDirect.appendingPathComponent(filename)
                // define the string/text to be saved
                let text = listcontent.text!
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                print("saving was successful")
            
                    let userID = Auth.auth().currentUser?.uid
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let metaData = StorageMetadata()
                    metaData.contentType = "Text/Plain"
                    let fileref = storageRef.child("text-files")
                    fileref.child(userID!).child(filename).putFile(from: fileURL, metadata: metaData){(metaData,error) in
                            if let error = error {
                                    print(error.localizedDescription)
                                return
                            }else{
                                fileref.child(userID!).child(filename).downloadURL(completion: { (url, error) in
                                    if (error == nil) {
                                        if let downloadUrl = url {
                                            // Make you download string
                                            let downloadString = downloadUrl.absoluteString
                                            print("DownloadURL: ", downloadString)
                                            var ref: DatabaseReference! = Database.database().reference()
                                            ref.child("users").child(userID!).child("list").child(nameoffile).setValue(downloadString)
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                            self.activityindactor.removeFromSuperview()
                                            
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Make_a_list_ID") as! Make_a_list
                                            self.present(vc, animated: true, completion: nil)
                                            
                                        }
                                    } else {
                                        // Do something if error
                                    }
                                })
                                
                        }
                    }
            } catch {
                print("error:", error)
            }
    }
}
