//
//  SinglesUserProfileViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-10.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class SinglesUserProfileViewController: UIViewController {
    
    // variables
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var instagramHandleLabel: UILabel!
    @IBOutlet weak var snapchatHandleLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var bioLabel: UILabel!
    
    // variables
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    let userToken = UserData().defaults.string(forKey: "userToken")
    var userID = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(userID)
        getUserData()
    }//end of viewDidLoad
    
    
    @IBAction func sendRequestPressed(_ sender: UIButton) {
        //make call to server
        print("promRequest pressed")
        let callURL = baseURL + "/php/match.php"
        let params : [String : Any] = ["token" : userToken!, "partner-id" : userID, "action" : 0]
        
        Alamofire.request(callURL, method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                print(response.result.value!)
                let matchJSON = JSON(response.result.value!)
                self.matchRequestStatus(matchJSON: matchJSON)
            } else {
                print("there was an error making the match request")
                print("here is the error code: \(response.result.value!)")
            }//end of if/else
        }//end of request
    }// end of sendRequest
    
    func matchRequestStatus(matchJSON : JSON) {
        
        if matchJSON["status"] == 200 {
            print("match request was sent sucessfully")
            let alert = UIAlertController(title: "Match Request", message: "The match request was sent sucessfully", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }//end of if
    }//end of matchRequestStatus
    
    func getUserData() {
        let callURL = baseURL + "/php/getUser.php"
        let params : [String : Any] = ["token" : userToken!, "id" : userID]
        
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("Sucess got Data")
                let dataJSON : JSON = JSON(response.result.value!)
                print("singlesUserProfile dataJSON")
                print(dataJSON)
                self.updateUI(userJSON: dataJSON)
            } else {
                print("Faliure to get Data, there was a problem getting the data")
                print("error: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of getUserData
    
    func updateUI(userJSON : JSON) {
        twitterHandleLabel.text = userJSON["result"]["user"]["SocialTwitter"].string
        snapchatHandleLabel.text = userJSON["result"]["user"]["SocialSnapchat"].string
        instagramHandleLabel.text = userJSON["result"]["user"]["SocialInstagram"].string
        bioLabel.text = userJSON["result"]["user"]["Biography"].string
        gradeLabel.text = "Grade: \(userJSON["result"]["user"]["Grade"])"
        nameLabel.text = "\(userJSON["result"]["user"]["FirstName"]) \(userJSON["result"]["user"]["LastName"])"
        schoolLabel.text = "School: \(userJSON["result"]["school"]["Name"])"
        navBar.title = "\(userJSON["result"]["user"]["FirstName"])'s Profile"
        
        let profilePicURL = userJSON["result"]["user"]["ProfilePicture"].string
        loadUserPicture(pictureURL: profilePicURL!)
        
        
    }//end of updateUI
    
    func loadUserPicture(pictureURL : String) {
        var profilePicURL = pictureURL
        let dotsIndex = profilePicURL.startIndex..<profilePicURL.index(profilePicURL.startIndex, offsetBy: 2)
        profilePicURL.removeSubrange(dotsIndex)
        
        let callURL = baseURL + profilePicURL
        
        Alamofire.request(callURL).responseImage {
            response in
            if response.result.isSuccess {
                let userImage = response.result.value
                self.userAvatar.image = userImage
            } else {
                print("there was a problem getting the image")
                print("error: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of loadUserPicture

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of SinglesUserProfileViewController
