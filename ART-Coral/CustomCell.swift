//
//  CustomCell.swift
//  ART-Coral
//
//  Created by Кирилл Трискало on 08.06.2018.
//  Copyright © 2018 Кирилл Трискало. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var about: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
