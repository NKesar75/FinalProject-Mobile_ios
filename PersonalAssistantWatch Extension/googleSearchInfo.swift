//
//  googleSearchInfo.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/7/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import Foundation
import WatchKit

class googleSearchInfo
{
    // 0 key // 1 title // 2 snippet // 3 url
    var title : String
    var snippet : String
    var url : String
    
    init(title: String, snippet: String, url : String)
    {
        self.title = title
        self.snippet = snippet
        self.url = url
    }
}
