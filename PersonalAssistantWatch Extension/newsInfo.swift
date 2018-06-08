//
//  newsInfo.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/7/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import Foundation
import WatchKit

class newsInfo
{
    var title : String
    var description : String
    var image : String
    var url : String
    
    init(title: String, description: String, image : String, url : String)
    {
        self.title = title
        self.description = description
        self.image = image
        self.url = url
    }
}
