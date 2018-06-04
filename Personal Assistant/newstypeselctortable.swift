//
//  newstypeselctortable.swift
//  Personal Assistant
//
//  Created by Hector Kesar on 6/4/18.
//  Copyright © 2018 Final-Project. All rights reserved.
//

import UIKit

class newstypeselctortable: UITableViewCell {

    @IBOutlet weak var typelabel: UILabel!
    @IBOutlet weak var newtypeimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
