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
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var partnerAvatar: UIImageView!
    
    @IBOutlet weak var userGradeLabel: UILabel!
    @IBOutlet weak var partnerGradeLabel: UILabel!
    @IBOutlet weak var userBioLabel: UITextView!
    @IBOutlet weak var partnerBioLabel: UITextView!
    @IBOutlet weak var userTwitterHandleLabel: UILabel!
    @IBOutlet weak var partnerTwitterHandleLabel: UILabel!
    @IBOutlet weak var userSnapchatHandleLabel: UILabel!
    @IBOutlet weak var partnerSnapchatHandleLabel: UILabel!
    @IBOutlet weak var userInstagramHandleLabel: UILabel!
    @IBOutlet weak var partnerInstagramHandleLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    
    var userID = ""
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    let userToken = UserData().defaults.string(forKey: "userToken")
    let placeholderImage = UIImage(named: "avatar_placeholder")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //we set the profilePic ImmageViews to circles
        userAvatar.layer.borderWidth = 1
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.borderColor = UIColor.black.cgColor
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true
        
        partnerAvatar.layer.borderWidth = 1
        partnerAvatar.layer.masksToBounds = false
        partnerAvatar.layer.borderColor = UIColor.black.cgColor
        partnerAvatar.layer.cornerRadius = partnerAvatar.frame.height/2
        partnerAvatar.clipsToBounds = true
        
        
        //we get the couple Data
        getCoupleData()
    }
    
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
        let userProfilePicURL = coupleJSON["result"]["user"]["ProfilePicture"].string
        let partnerProfilePicURl = coupleJSON["result"]["partner"]["ProfilePicture"].string
        let userCallURL = baseURL + userProfilePicURL!
        let partnerCallURL = baseURL + partnerProfilePicURl!
        let userURLRequest = URL(string: userCallURL)
        let partnerURLRequest = URL(string: partnerCallURL)
        
        //we load the user Data
        //grade, bio, twitter handle,snapchat handle, insta handle, page title
        userGradeLabel.text = coupleJSON["result"]["user"]["Grade"].string
        userBioLabel.text = coupleJSON["result"]["user"]["Biography"].string
        userTwitterHandleLabel.text = coupleJSON["result"]["user"]["SocialTwitter"].string
        userSnapchatHandleLabel.text = coupleJSON["result"]["user"]["SocialSnapchat"].string
        userInstagramHandleLabel.text = coupleJSON["result"]["user"]["SocialInstagram"].string
        userAvatar.af_setImage(withURL: userURLRequest!, placeholderImage: placeholderImage)
        
        //we load the partner data
        partnerGradeLabel.text = coupleJSON["result"]["partner"]["Grade"].string
        partnerBioLabel.text = coupleJSON["result"]["partner"]["Biography"].string
        partnerTwitterHandleLabel.text = coupleJSON["result"]["partner"]["SocialTwitter"].string
        partnerSnapchatHandleLabel.text = coupleJSON["result"]["partner"]["SocialSnapchat"].string
        partnerInstagramHandleLabel.text = coupleJSON["result"]["partner"]["SocialInstagram"].string
        partnerAvatar.af_setImage(withURL: partnerURLRequest!, placeholderImage: placeholderImage)
        
        //nav bar title name&names' profile or name&name' coupleProfile
        navBar.title = "\(coupleJSON["result"]["user"]["FirstName"]) & \(coupleJSON["result"]["partner"]["FirstName"])' Couple Profile"
    }//end of updateCoupleUI
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
