//
//  CustomCellTableViewCell.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 4/26/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customcellview: UIView!
    @IBOutlet weak var customcelltitle: UILabel!
    @IBOutlet weak var customcellsnippet: UITextView!
    @IBOutlet weak var customcellurl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
