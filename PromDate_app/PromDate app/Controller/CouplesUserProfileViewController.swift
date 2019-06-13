//
//  CouplesUserProfileViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-21.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class CouplesUserProfileViewController: UIViewController {
    
    //variables
    @IBOutlet weak var userAvatarButton: UIButton!
    @IBOutlet weak var partnerAvatarButton: UIButton!
    
    @IBOutlet weak var userGradeLabel: UILabel!
    @IBOutlet weak var partnerGradeLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userSchoolLabel: UILabel!
    @IBOutlet weak var partnerSchoolLabel: UILabel!
    @IBOutlet weak var partnerNameLabel: UILabel!
    
    var userID = ""
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    let userToken = UserData().defaults.string(forKey: "userToken")
    let placeholderImage = UIImage(named: "avatar_placeholder")
    var partnerID = ""
    var selectedUserID = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //we set the profilePic ImmageViews to circles
        
        userAvatarButton.layer.borderWidth = 1
        userAvatarButton.layer.masksToBounds = false
        userAvatarButton.layer.borderColor = UIColor.black.cgColor
        userAvatarButton.layer.cornerRadius = userAvatarButton.frame.height/2
        userAvatarButton.clipsToBounds = true
        
        partnerAvatarButton.layer.borderColor = UIColor.black.cgColor
        partnerAvatarButton.layer.borderWidth = 1
        partnerAvatarButton.layer.masksToBounds = false
        partnerAvatarButton.layer.cornerRadius = partnerAvatarButton.frame.height/2
        partnerAvatarButton.clipsToBounds = true
        
        
        //we get the couple Data
        getCoupleData()
    }//end of viewDidLoad
    
    
//    @IBAction func userPicPressed(_ sender: Any) {
//        let alert = UIAlertController(title: "Go to user?", message: "Do you want to see this user's profile?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
//            self.selectedUserID = self.userID
//            self.performSegue(withIdentifier: "goToSelectedUser", sender: self)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }//end of userPicPressed
    
//    @IBAction func partnerPicPressed(_ sender: Any) {
//        print("partner pic selected")
//    }//end of partnerPicPressed
    
    @IBAction func userPicPressed(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Go to user?", message: "Do you want to see this user's profile?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
//            self.selectedUserID = self.userID
//            self.performSegue(withIdentifier: "goToSelectedUser", sender: self)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
        
        self.selectedUserID = self.userID
        self.performSegue(withIdentifier: "goToSelectedUser", sender: self)
    }//end of userPicPressed
    
    @IBAction func partnerPicPressed(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Go to user?", message: "Do you want to see this user's profile?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
//            self.selectedUserID = self.partnerID
//            self.performSegue(withIdentifier: "goToSelectedUser", sender: self)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
        
        self.selectedUserID = self.partnerID
        self.performSegue(withIdentifier: "goToSelectedUser", sender: self)
        
    }//end of userPicPressed
    
    
    func getCoupleData() {
        let callURL = baseURL + "/php/getUser.php"
        let params : [String : Any] = ["token" : userToken!, "id" : userID]
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got Data")
                let coupleJSON : JSON = JSON(response.result.value!)
                self.updateCoupleUI(coupleJSON: coupleJSON)
            } else {
                print("there was an error getting the Data")
                print("here is the error code: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of getCoupleData
    
    func updateCoupleUI(coupleJSON : JSON) {
        print(coupleJSON)
        
        //we load the userProfilePics
        var userProfilePicURL = coupleJSON["result"]["user"]["ProfilePicture"].string!
        var partnerProfilePicURl = coupleJSON["result"]["partner"]["ProfilePicture"].string!
        
        let userSlashIndex = userProfilePicURL.startIndex..<userProfilePicURL.index(userProfilePicURL.startIndex, offsetBy: 2)
        let prtnSlashIndex = partnerProfilePicURl.startIndex..<partnerProfilePicURl.index(partnerProfilePicURl.startIndex, offsetBy: 2)
        
        if userProfilePicURL[userSlashIndex] == "\\/" {
            userProfilePicURL.removeSubrange(userSlashIndex)
        }//end of if
        if partnerProfilePicURl[prtnSlashIndex] == "\\/" {
            partnerProfilePicURl.removeSubrange(prtnSlashIndex)
        }//end of if
        
        
        let userCallURL = baseURL + "/\(userProfilePicURL)"
        let partnerCallURL = baseURL + "/\(partnerProfilePicURl)"
        let userURLRequest = URL(string: userCallURL)
        let partnerURLRequest = URL(string: partnerCallURL)
        partnerID = coupleJSON["result"]["partner"]["ID"].string!
        
        //we load the user Data
        //grade, bio, twitter handle,snapchat handle, insta handle, page title
        userGradeLabel.text = "Grade: \(coupleJSON["result"]["user"]["Grade"])"
        userAvatarButton.af_setImage(for: .normal, url: userURLRequest!, placeholderImage: placeholderImage)
        //we load the partner data
        partnerGradeLabel.text = "Grade: \(coupleJSON["result"]["partner"]["Grade"])"
        partnerAvatarButton.af_setImage(for: .normal, url: partnerURLRequest!, placeholderImage: placeholderImage)
    
        //nav bar title name&names' profile or name&name' coupleProfile and the school Label
        navBar.title = "\(coupleJSON["result"]["user"]["FirstName"]) & \(coupleJSON["result"]["partner"]["FirstName"])' Couple Profile"
        userSchoolLabel.text = "\(coupleJSON["result"]["school"]["Name"])"
        partnerSchoolLabel.text = "\(coupleJSON["result"]["school"]["Name"])"
        userNameLabel.text = "\(coupleJSON["result"]["user"]["FirstName"]) \(coupleJSON["result"]["user"]["LastName"])"
        partnerNameLabel.text = "\(coupleJSON["result"]["partner"]["FirstName"]) \(coupleJSON["result"]["partner"]["LastName"])"
    }//end of updateCoupleUI
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedUser" {
            let destinationVC = segue.destination as! SinglesUserProfileViewController
            destinationVC.userID = selectedUserID
        }//end of if
    }//end of prepareForSegue
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
