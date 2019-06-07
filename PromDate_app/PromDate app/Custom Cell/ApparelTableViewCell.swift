//
//  ApparelTableViewCell.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-06-07.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class ApparelTableViewCell: UITableViewCell {
    
    //variables
    @IBOutlet weak var apparelImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var modelNumberLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
