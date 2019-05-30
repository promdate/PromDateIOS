//
//  CouplesUserModel.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-23.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import Foundation

class CouplesUserModel {
    //variables declaration
    let userSchoolID : String
    let userFirstName : String
    let userLastName : String
    let userBio : String
    let userGender : String
    let userID : String
    let userGrade : String
    let userPicURL : String
    
    //partner info
    let partnerSchoolID : String
    let partnerFirstName : String
    let partnerLastName : String
    let partnerBio : String
    let partnerGender : String
    let partnerID : String
    let partnerGrade : String
    let partnerPicURL : String
    
    init(usrSchoolID : String, usrFirstName : String, usrLastName : String, usrBio : String, usrGender : String, usrID : String, usrGrade : String, prtnSchoolID : String, prtnFirstName : String, prtnLastName : String, prtnBio : String, prtnGender : String, prtnID : String, prtnGrade : String, usrPic : String, prtnPic : String) {
        userSchoolID = usrSchoolID
        userFirstName = usrFirstName
        userLastName = usrLastName
        userBio = usrBio
        userGender = usrGender
        userID = usrID
        userGrade = usrGrade
        partnerSchoolID = prtnSchoolID
        partnerFirstName = prtnFirstName
        partnerLastName = prtnLastName
        partnerBio = prtnBio
        partnerGender = prtnGender
        partnerID = prtnID
        partnerGrade = prtnGrade
        userPicURL = usrPic
        partnerPicURL = prtnPic
        
    }//end of init
}//end of CouplesUserModel
