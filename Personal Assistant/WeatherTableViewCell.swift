//
//  WeatherTableViewCell.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/30/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherview: UIView!
    @IBOutlet weak var weatherimage: UIImageView!
    @IBOutlet weak var weatherforcast: UILabel!
    @IBOutlet weak var weatherhumidty: UILabel!
    @IBOutlet weak var weatherrain: UILabel!
    @IBOutlet weak var weathertemplow: UILabel!
    @IBOutlet weak var weathertemphigh: UILabel!
    @IBOutlet weak var weatherlocation: UILabel!
    @IBOutlet weak var Weatherdayoftheyear: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
