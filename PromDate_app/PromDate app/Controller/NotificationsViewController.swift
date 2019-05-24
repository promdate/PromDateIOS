//
//  NotificationsViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-16.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //variables
    @IBOutlet weak var notificationTableView: UITableView!
    
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var userToken = UserData().defaults.string(forKey: "userToken")
    var notificationJSON : JSON!
    var notificationSender : [String]!
    var senderID = ""
    var matchAction = 2
    var notificationArray = [NotificationModel]()
    var notificationArrayFilled = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //setting self as delegate and dataSource for tableView
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        //register cell
        notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        
        //we call congifureTableView to set the height of the cells
        configureTableView()
        
        //we set the notificationArrayFilled var to false
        notificationArrayFilled = false
        
        //we call getNotificationData
        getNotificationData()
    }//end of viewDidLoad
    
    //MARK: - Declare cellForRowAt method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //we declare the cell which will be used for the notification information
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        cell.avatarImageView.image = UIImage(named: "avatar_placeholder")
        
        print(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"])
//        switch notificationJSON["result"]["notifications"][indexPath.row]["Type"]{
//        case "1":
//            cell.titleLabel.text = "Match Requested"
//            cell.messageLabel.text = "\(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["FirstName"]) \(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["LastName"]) has sent a match request"
//        case "2":
//            cell.titleLabel.text = "Match Declined"
//            cell.messageLabel.text = "\(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["FirstName"]) \(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["LastName"])"
//        case "3":
//            cell.titleLabel.text = "Match Accepted"
//            cell.messageLabel.text = "\(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["FirstName"]) \(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["LastName"])"
//        case "4":
//            cell.titleLabel.text = "Unmatch Notice"
//            cell.messageLabel.text = "\(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["FirstName"]) \(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["LastName"])"
//        default:
//            cell.messageLabel.text = notificationJSON["result"]["notifications"][indexPath.row]["Message"].string
//        }//end of switch
        switch notificationArray[indexPath.row].type {
        case "1":
            print("case 1")
            cell.titleLabel.text = "Match Requested"
            cell.messageLabel.text = notificationArray[indexPath.row].message
        case "2":
            print("case 2")
            cell.titleLabel.text = "Match Declined"
            cell.messageLabel.text = notificationArray[indexPath.row].message
        case "3":
            print("case 3")
            cell.titleLabel.text = "Match Accepted"
            cell.messageLabel.text = notificationArray[indexPath.row].message
        case "4":
            print("case 4")
            cell.titleLabel.text = "Unmatch Notice"
            cell.messageLabel.text = notificationArray[indexPath.row].message
        default:
            print("default picked")
            cell.titleLabel.text = "Unknown notification type"
            cell.messageLabel.text = notificationArray[indexPath.row].message
        }//end of switch
        
        return cell
    }//end of cellForRowAt
    
    
    
    //MARK: - Declare numberOfRowsInSection method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //we check if notificationJSON has some data and if that's the case we return the quantity of notifications
//        if notificationJSON != nil {
//            print("notification count: \(notificationJSON["result"]["notifications"].count)")
//            return notificationJSON["result"]["notifications"].count
//
//        } else {
//            return 0
//        }//end of if/else
        if notificationArrayFilled == true {
            return notificationArray.count
        } else {
            return 0
        }//end of if/else
    }//end of numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        senderID = notificationJSON["result"]["notifications"][indexPath.row]["Parameters"].string!
//        let dotsIndex = senderID.startIndex..<senderID.index(senderID.endIndex, offsetBy: -3)
//        senderID.removeSubrange(dotsIndex)
        senderID = notificationArray[indexPath.row].senderID
        performSegue(withIdentifier: "goToSelectedUser", sender: self)
        
    }//fin de didSelectRowAt
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("ID: \(notificationJSON["result"]["notifications"][indexPath.row]["ParametersJSON"][0]["initiator-data"]["ID"])")
        senderID = notificationArray[indexPath.row].senderID
        
//        let dotsIndex = senderID.startIndex..<senderID.index(senderID.endIndex, offsetBy: -3)
//        senderID.removeSubrange(dotsIndex)
        
        if notificationJSON["result"]["notifications"][indexPath.row]["Type"] == "1" {
            let alert = UIAlertController(title: "Match Request", message: "User __ sent you a match request", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Accept Match", style: .default, handler: { (UIAlertAction) in
                print("match request accepted")
                self.matchAction = 0
                self.replyMatchRequest()
            }))
            alert.addAction(UIAlertAction(title: "Deny Match", style: .default, handler: { (UIAlertAction) in
                print("match denied")
                self.matchAction = 1
                self.replyMatchRequest()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }//end of if
    }//end of accessoryButtonTappedForRowWith
    
    func getNotificationData(){
        let callURL = baseURL + "/php/notifications.php"
        let params : [String : Any] = ["token" : userToken!]
        
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got notification Data!")
                self.notificationJSON = JSON(response.result.value!)
                print(self.notificationJSON)
                self.processNotificationData()
                //self.loadNotificationData()
                //self.notificationTableView.reloadData()
            } else {
                print("there was an error getting the notification data")
                print("this is the error code: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of getNotificationData
    
    func processNotificationData() {
        if notificationJSON["result"]["notifications"].count >= 1 {
            for index in 0...notificationJSON["result"]["notifications"].count - 1 {
                notificationArray.append(NotificationModel(notificationTime: notificationJSON["result"]["notifications"][index]["CreationTime"].string!, notificationViewed: notificationJSON["result"]["notifications"][index]["Viewed"].string!, notificationID: notificationJSON["result"]["notifications"][index]["ID"].string!, notificationType: notificationJSON["result"]["notifications"][index]["Type"].string!, senderLastName: notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["LastName"].string!, senderFirstName: notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["FirstName"].string!, senderProfilePicURL: notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["ProfilePicture"].string!, initiatorID: notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["ID"].string!, notificationMessage: notificationJSON["result"]["notifications"][index]["Message"].string!))
            }//end of for loop
            //we set notificationArrayFilled to true and refresh the tableViewData
            notificationArrayFilled = true
            notificationTableView.reloadData()
        }//end of if
        
    }//end of processNotificationData
    
    func configureTableView() {
        notificationTableView.rowHeight = UITableView.automaticDimension
        notificationTableView.estimatedRowHeight = 60.0
    }//end of configureTableView
    
//    func loadNotificationData() {
//        //code which extracts the senderID
//        //code which gives the var SenderID the value of what was just extracted
//        //alamofire call which finds the user name
//        //when this alamofire request is finished, extract the link for the picture url and make another alamofire call where we extract the picture and append it to an array
//        //when all of that is completed use the reloadData method to load all of the information for the notification page
//
//        //loop which repeats itself until all of the data is loaded
////        for index in 0...quantityOfNotifications - 1 {
////
////        }//end of for loop
//        //self.notificationTableView.reloadData()
//    }//end of loadNotificationData
    
    func replyMatchRequest() {
        let callURL = baseURL + "/php/match.php"
        let params : [String : Any] = ["token" : userToken!, "partner-id" : senderID, "action" : matchAction]
        Alamofire.request(callURL, method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                let responseJSON : JSON = JSON(response.result.value!)
                print(responseJSON)
                
            } else {
                print("there was an issue answering the match request")
                print("here is the error code: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of replyMatchRequest
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedUser" {
            let destinationVC = segue.destination as! SinglesUserProfileViewController
            destinationVC.userID = senderID
        }
    }//end of prepareForSegue

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of NotificationsViewController
