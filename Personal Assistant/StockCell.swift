//
//  StockCell.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/6/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {
    @IBOutlet weak var nameofcompany: UILabel!
    @IBOutlet weak var Priceofstock: UILabel!
    @IBOutlet weak var Sizeofstock: UILabel!
    @IBOutlet weak var imageforcompany: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

