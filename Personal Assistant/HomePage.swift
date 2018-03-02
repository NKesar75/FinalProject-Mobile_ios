//
//  HomePage.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 3/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit
import Firebase

class HomePage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func Signout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "Signout_seg", sender: nil)
        } catch {
            print(error)
        }
    }
    

}
