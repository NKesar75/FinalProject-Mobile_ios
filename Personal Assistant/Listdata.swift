//
//  Listdata.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

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
        
    }

}
