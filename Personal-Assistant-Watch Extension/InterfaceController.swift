//
//  InterfaceController.swift
//  Personal-Assistant-Watch Extension
//
//  Created by Hector Kesar on 5/2/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var myLabel: WKInterfaceLabel!
    
    var aResult : String?
    
    @IBAction func inputBtn()
    {
        let textChoices = ["What is the Weather","Play Despacito","Search for Game of Thrones"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.plain,
                                   completion: {(results) -> Void in if results != nil && results!.count > 0 { //selection made
                                    self.aResult = results?[0] as? String
                                    print(self.aResult!)
                                    self.myLabel.setText(self.aResult)
                                    }
        }
        )
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        let textChoices = ["What is the Weather","Play Despacito","Search for Game of Thrones"]
        presentTextInputController(withSuggestions: textChoices, allowedInputMode: WKTextInputMode.plain,
                                   completion: {(results) -> Void in if results != nil && results!.count > 0 { //selection made
                                    self.aResult = results?[0] as? String
                                    print(self.aResult!)
                                    self.myLabel.setText(self.aResult)
                                    }
        }
        )
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
