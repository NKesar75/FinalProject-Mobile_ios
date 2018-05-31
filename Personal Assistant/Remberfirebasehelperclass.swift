//
//  Remberfirebasehelperclass.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 5/30/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import Foundation
import Firebase

class Remberfirebasehelperclass
{
    
    func pushtofirebase(link:String, type:String)
    {
        let userID = Auth.auth().currentUser?.uid
        let ref: DatabaseReference! = Database.database().reference().child("users").child(userID!).child("remeb")
        ref.child(link).setValue(type)
    }
    
    func deletefromfirebase(link:String)
    {
        let userID = Auth.auth().currentUser?.uid
        let ref: DatabaseReference! =  Database.database().reference().child("users").child(userID!).child("remeb").child(link)
        ref.removeValue()
    }
    
}
