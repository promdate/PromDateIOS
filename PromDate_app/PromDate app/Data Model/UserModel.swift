//
//  UserModel.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-23.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import Foundation
class UserModel {
    
    //variables declaration
    let userGender : String
    let userGrade : String
    let userLastName : String
    let userSchoolID : String
    let userBio : String
    let id : String
    let userFirstName : String
    let userPicURL : String
    
    
    //init
    init(gender : String, grade : String, lastName : String, schoolID : String, bio : String, userID : String, firstName : String, profilePicURL : String) {
        userGender = gender
        userGrade = grade
        userLastName = lastName
        userSchoolID = schoolID
        userBio = bio
        id = userID
        userFirstName = firstName
        userPicURL = profilePicURL
    }//end of the initialisation
}//end of UserModel
