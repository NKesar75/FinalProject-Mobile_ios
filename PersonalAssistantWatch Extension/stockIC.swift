//
//  stockIC.swift
//  PersonalAssistantWatch Extension
//
//  Created by Raj  Chandan on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import WatchKit
import Foundation


class stockIC: WKInterfaceController {

    @IBOutlet var stocksTable: WKInterfaceTable!
    
    struct stockInfo
    {
        var name : String
        var price : String
        var capacity : String
        var img : String
    }
    
    var stockList : [stockInfo] = []
    
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
    
    func loadDataintoTable()
    {
        fetchperviouscall()
        stocksTable.setNumberOfRows(stockList.count, withRowType: "stocksRowController")
        for (index, _) in stockList.enumerated()
        {
            if let rowController = stocksTable.rowController(at: index) as? stocksRowController
            {
                rowController.stocksName.setText(stockList[index].name)
                rowController.stocksPrice.setText(stockList[index].price)
                rowController.stocksCapacity.setText(stockList[index].capacity)
                rowController.stocksImg.setImageNamed(stockList[index].img)
            }
        }
    }

    func fetchperviouscall()
    {
        if HomePageIC.stockInfo != nil
        {
            let stockarray = HomePageIC.stockInfo.split(separator: ",")
            
            for i in stride(from: 1, to: 80, by: 4)
            {
                stockList.append(stockInfo(name: String(stockarray[i]), price: "$" + stockarray[i + 1], capacity: "Size:" + stockarray[i + 2], img: String(stockarray[i + 3])))
            }
        }
    }
}
