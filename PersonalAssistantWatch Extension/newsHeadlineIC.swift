//
//  newsHeadlineIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/7/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation


class newsHeadlineIC: WKInterfaceController {

    @IBOutlet var newsHeadlineTable: WKInterfaceTable!
    
    var newsList: [newsInfo] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        loadDataintoTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int)
    {
        pushController(withName: "newsInfoIdentifier", context: newsList[rowIndex])
    }
    
    func loadDataintoTable()
    {
        fetchperviouscall()
        newsHeadlineTable.setNumberOfRows(newsList.count, withRowType: "newsHeadlineRowController")
        
        for (index, _) in newsList.enumerated()
        {
            if let rowController = newsHeadlineTable.rowController(at: index) as? newsHeadlineRowController
            {
                rowController.newsHeadline.setText(newsList[index].title)
                let imgUrl = newsList[index].image
                if let url = URL(string: imgUrl)
                {
                    do
                    {
                        let data = try Data(contentsOf: url)
                        rowController.newsImg.setImageData(data)
                    }
                    catch let error
                    {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func fetchperviouscall()
    {
        
        if newsIC.newsData != nil
        {
            let newsArray = newsIC.newsData.split(separator: "\u{1D6FF}")
            print("Array count",newsArray.count)
            for i in stride(from: 1, to: newsArray.count-1, by: 4)
            {
                newsList.append(newsInfo(title: String(newsArray[i]), description: String(newsArray[i + 1]), image: String(newsArray[i + 2]), url: String(newsArray[i + 3])))

            }
        }
    }
}
