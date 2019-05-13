//
//  SinglesUserProfileViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-10.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
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
    }// end of sendRequest
    
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
    }//end of updateUI

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of SinglesUserProfileViewController
