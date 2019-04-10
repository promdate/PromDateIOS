//
//  CouplesTableViewCell.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-09.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class CouplesTableViewCell: UITableViewCell {

    @IBOutlet weak var firstAvatarImageView: UIImageView!
    @IBOutlet weak var seccondAvatarImageView: UIImageView!
    @IBOutlet weak var couplesNamesLabel: UILabel!
    @IBOutlet weak var promSchoolLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
