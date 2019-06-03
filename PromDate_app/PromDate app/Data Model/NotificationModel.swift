//
//  NotificationModel.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-24.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import Foundation

class NotificationModel {
    //variables
    let creationTime : String
    let viewed : String
    let id : String
    let type : String
    let message : String
    
    //sender vars
    let lastName : String
    let firstName : String
    let profileURL : String
    let senderID : String
    
    
    init(notificationTime : String, notificationViewed : String, notificationID : String, notificationType : String, senderLastName : String, senderFirstName : String, senderProfilePicURL : String, initiatorID : String, notificationMessage : String) {
        creationTime = notificationTime
        viewed = notificationViewed
        id = notificationID
        type = notificationType
        lastName = senderLastName
        firstName = senderFirstName
        profileURL = senderProfilePicURL
        senderID = initiatorID
        message = notificationMessage
    }//end of init
}//end of NotificationModel
