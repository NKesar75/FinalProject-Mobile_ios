//
//  Login.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 3/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController {
    
    
    var loginlabelbool = true
    
    @IBOutlet weak var SigninSelecter: UISegmentedControl!
    @IBOutlet weak var SigninLabel: UILabel!
    @IBOutlet weak var Emailvalue: UITextField!
    @IBOutlet weak var Passwordvalue: UITextField!
    @IBOutlet weak var submitbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Login.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage_ID") as! HomePage
            self.present(vc, animated: true, completion: nil)
        }
        super.viewDidAppear(animated)
    }
    @IBAction func LoginLabelChanged(_ sender: Any) {
        loginlabelbool = !loginlabelbool
        
        if loginlabelbool {
            SigninLabel.text = "Login"
            submitbutton.setTitle("Login", for: .normal)
        }else{
            SigninLabel.text = "Sign Up"
            submitbutton.setTitle("Register", for: .normal)
        }
    }

//Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
}
    @IBAction func Signinbuttonclicked(_ sender: Any) {
        if loginlabelbool {
            
            guard let email = Emailvalue.text,
                email != "",
                let password = Passwordvalue.text,
                password != ""
                else{
                    AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                    return
            }
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error {
                        AlertController.showAlert(self, title: "Error", message: error.localizedDescription)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage_ID") as! HomePage
                        self.present(vc, animated: true, completion: nil)
                    }
//                    guard let user = user else { return }
//                    //print(user.email ?? "MISSING EMAIL")
//                    //print(user.uid)
                })
            
        }else{
            guard let email = Emailvalue.text,
                email != "",
                let password = Passwordvalue.text,
                password != ""
                else{
                     AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                    return
            }
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user,error ) in
                   
                    if let error = error {
                        AlertController.showAlert(self, title: "Error", message: error.localizedDescription)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage_ID") as! HomePage
                        self.present(vc, animated: true, completion: nil)
                    }
                    //guard let user = user else { return }
                    //print(user.email ?? "MISSING EMAIL")
                    //print(user.uid)
                })
        }
    }
}



