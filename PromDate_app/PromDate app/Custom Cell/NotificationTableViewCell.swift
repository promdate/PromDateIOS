//
//  NotificationTableViewCell.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-17.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    
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
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            avatarImageView.layer.borderColor = UIColor.label.cgColor
        }//end of if
    }//end of traitCollectionDidChange
}//end of NotificationTableViewCell
