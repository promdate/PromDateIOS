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
import AlamofireImage

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //variables
    @IBOutlet weak var notificationTableView: UITableView!
    
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var userToken = UserData().defaults.string(forKey: "userToken")
    var senderID = ""
    var matchAction = 2
    var notificationArray = [NotificationModel]()
    //var imageArray = [UIImage]()
    var notificationArrayFilled = false
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //setting self as delegate and dataSource for tableView
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        configureTableView()
        configureRefreshControl()
        
        //register cell
        notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        
        //we call congifureTableView to set the height of the cells
        //configureTableView()
        
        //we set the notificationArrayFilled var to false
        notificationArrayFilled = false
        
        //we call getNotificationData
        getNotificationData()
    }//end of viewDidLoad
    
    //MARK: - Declare cellForRowAt method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //we declare the cell which will be used for the notification information
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        let pictureURL = notificationArray[indexPath.row].profileURL
        let callURL = baseURL + pictureURL
        let placeholderImage = UIImage(named: "avatar_placeholder")
        let urlRequest = URL(string: callURL)
        let notificationDate = NSDate(timeIntervalSince1970: Double(notificationArray[indexPath.row].creationTime)!)
        
        switch notificationArray[indexPath.row].type {
        case "1":
            print("case 1")
            cell.titleLabel.text = "Match Requested"
            cell.messageLabel.text = notificationArray[indexPath.row].message
            cell.timeStampLabel.text = offsetFrom(date: notificationDate as Date)
            cell.statusImageView.isHidden = true
            cell.accessoryType = .detailButton
            cell.avatarImageView!.af_setImage(withURL: urlRequest!, placeholderImage: placeholderImage)
        case "2":
            print("case 2")
            cell.titleLabel.text = "Match Declined"
            cell.messageLabel.text = notificationArray[indexPath.row].message
            cell.timeStampLabel.text = offsetFrom(date: notificationDate as Date)
            cell.statusImageView.image = UIImage(named: "heart_broken")
            cell.statusImageView.isHidden = false
            cell.accessoryType = .none
            cell.avatarImageView!.af_setImage(withURL: urlRequest!, placeholderImage: placeholderImage)
        case "3":
            print("case 3")
            cell.titleLabel.text = "Match Accepted"
            cell.messageLabel.text = notificationArray[indexPath.row].message
            cell.timeStampLabel.text = offsetFrom(date: notificationDate as Date)
            cell.statusImageView.image = UIImage(named: "heart_filled")
            cell.statusImageView.isHidden = false
            cell.accessoryType = .none
            cell.avatarImageView!.af_setImage(withURL: urlRequest!, placeholderImage: placeholderImage)
        case "4":
            print("case 4")
            cell.titleLabel.text = "Unmatch Notice"
            cell.messageLabel.text = notificationArray[indexPath.row].message
            cell.timeStampLabel.text = offsetFrom(date: notificationDate as Date)
            cell.statusImageView.image = UIImage(named: "heart_broken")
            cell.statusImageView.isHidden = false
            cell.accessoryType = .none
            cell.avatarImageView!.af_setImage(withURL: urlRequest!, placeholderImage: placeholderImage)
        case "5":
            print("case 5")
            cell.titleLabel.text = "Admin Unmatch Notice"
            cell.messageLabel.text = notificationArray[indexPath.row].message
            cell.timeStampLabel.text = offsetFrom(date: notificationDate as Date)
            cell.statusImageView.isHidden = true
            cell.accessoryType = .none
        default:
            print("default picked")
            cell.titleLabel.text = "Unknown notification type"
            cell.messageLabel.text = notificationArray[indexPath.row].message
            cell.timeStampLabel.text = offsetFrom(date: notificationDate as Date)
            cell.statusImageView.isHidden = true
            cell.accessoryType = .none
        }//end of switch
        return cell
    }//end of cellForRowAt
    
    
    //MARK: - Declare numberOfRowsInSection method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //we check if notificationArrayFilled is true and if that's the case we return the quantity of notifications
        if notificationArrayFilled == true {
            return notificationArray.count
        } else {
            return 0
        }//end of if/else
    }//end of numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        senderID = notificationArray[indexPath.row].senderID
        performSegue(withIdentifier: "goToSelectedUser", sender: self)
        
    }//fin de didSelectRowAt
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        senderID = notificationArray[indexPath.row].senderID
        
        if notificationArray[indexPath.row].type == "1" {
            let alert = UIAlertController(title: "Match Request", message: notificationArray[indexPath.row].message, preferredStyle: .alert)
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
                let responseJSON = JSON(response.result.value!)
                print("responseJSON: \(responseJSON)")
                self.processNotificationData(notificationJSON: responseJSON)
            } else {
                print("there was an error getting the notification data")
                print("this is the error code: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of getNotificationData
    
    func processNotificationData(notificationJSON : JSON) {
        if notificationJSON["result"]["notifications"].count >= 1 {
            for index in 0...notificationJSON["result"]["notifications"].count - 1 {
                var senderPicURL = notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["ProfilePicture"].string!
                let userSlashIndex = senderPicURL.startIndex..<senderPicURL.index(senderPicURL.startIndex, offsetBy: 2)
                if senderPicURL[userSlashIndex] == "\\/" {
                    senderPicURL.removeSubrange(userSlashIndex)
                }//end of if
                print("entered process for loop")
                notificationArray.append(NotificationModel(notificationTime: notificationJSON["result"]["notifications"][index]["CreationTime"].string!, notificationViewed: notificationJSON["result"]["notifications"][index]["Viewed"].string!, notificationID: notificationJSON["result"]["notifications"][index]["ID"].string!, notificationType: notificationJSON["result"]["notifications"][index]["Type"].string!, senderLastName: notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["LastName"].string!, senderFirstName: notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["FirstName"].string!, senderProfilePicURL: "/\(senderPicURL)", initiatorID: notificationJSON["result"]["notifications"][index]["ParametersJSON"][0]["initiator-data"]["ID"].string!, notificationMessage: notificationJSON["result"]["notifications"][index]["Message"].string!))
            }//end of for loop
            //we set notificationArrayFilled to true and refresh the tableViewData
            notificationArrayFilled = true
            notificationTableView.reloadData()
        }//end of if
    }//end of processNotificationData
    
    func offsetFrom(date : Date) -> String {
        let currentDate = Date()
        let dayHourMinuteSecond : Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: currentDate)
        
        let seconds = "\(difference.second ?? 0)s ago"
        let minutes = "\(difference.minute ?? 0)m ago"
        let hours = "\(difference.hour ?? 0)h ago"
        let days = "\(difference.day ?? 0)d ago"
        
        if let day = difference.day, day > 0 { return days }
        if let hour = difference.day, hour > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }//end of offsetFrom
    
    //function replyMatchRequest --> called when accesory button is tapped and user picks accept/decline
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
        }//end of if
    }//end of prepareForSegue
    
    
    //MARK: - Declare configuration functions
    func configureTableView() {
        notificationTableView.rowHeight = 70.0
        notificationTableView.estimatedRowHeight = 70.0
    }//end of configureTableView
    
    //function configureRefreshControl --> called in viewDidLoad and sets up functionality to refresh the tableView with bounce
    func configureRefreshControl() {
        //we create the refreshControl ( scrolling wheel and assign it to an action)
        notificationTableView.refreshControl = UIRefreshControl()
        
        //we assign the action/object to the tableView so that when the user
        notificationTableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }//end of configureRefreshControl
    
    //object function handleRefreshControl --> called when refresh is activated & has the physical refresh code
    @objc func handleRefreshControl() {
        //update content
        refreshTableView()
        
        //when refreshing has ended we dismiss the refreshControl
        DispatchQueue.main.async {
            self.notificationTableView.refreshControl?.endRefreshing()
        }//end of dispatchQueue
    }//enbd of handleRefreshControl
    
    //func refreshTableView
    func refreshTableView() {
        //we remove all of the data stored in notificationArray
        notificationArray.removeAll()
        notificationArrayFilled = false
        getNotificationData()
    }//end of refreshTableView
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of NotificationsViewController
