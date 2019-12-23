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
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.masksToBounds = false
        //avatarImageView.layer.borderColor = UIColor.black.cgColor
        avatarImageView.layer.borderColor = UIColor.label.cgColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
        avatarImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("traitCollectionDidChange was called")
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)   {
            print("if traitCollection.hasDifferentColorApperance was called")
            avatarImageView.layer.borderColor = UIColor.label.cgColor
        } //end of if
    }//end of traitCollectionDidChange
    
}
