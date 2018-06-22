//
//  splashScreenIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/21/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation
import UIKit

class splashScreenIC: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        pushController(withName: "HomepageIdentifier", context: nil)
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
