//
//  ProfilePictureModel.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-25.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import Foundation
import UIKit

class ProfilePictureModel {
    let userPicture : UIImage
    let partnerPicture : UIImage
    
    init(usrPicture : UIImage, prtnPicture : UIImage) {
        userPicture = usrPicture
        partnerPicture = prtnPicture
    }//end of initialisation
}//end of ProfilePictureModel
