//
//  SinglesTableViewCell.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-09.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class SinglesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
