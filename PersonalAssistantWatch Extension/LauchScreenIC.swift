//
//  LauchScreenIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/27/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation

class LauchScreenIC: WKInterfaceController {
    
    @IBOutlet var appLogo: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            self.pushController(withName: "HomepageIdentifier", context: nil)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
