//
//  NewsTableViewCell.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/4/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {


    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titleofnews: UILabel!
    @IBOutlet weak var athorofnews: UILabel!
    @IBOutlet weak var urlofnews: UILabel!
    @IBOutlet weak var descofnews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
