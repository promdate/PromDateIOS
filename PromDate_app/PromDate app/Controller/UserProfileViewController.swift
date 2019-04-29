//
//  UserProfileViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-25.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserProfileViewController: UIViewController {
    
    //variables
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    @IBOutlet weak var twitterHandleTextField: UITextField!
    @IBOutlet weak var snapchatHandleTextField: UITextField!
    @IBOutlet weak var instagramHandleTextField: UITextField!
    
    
    struct Data {
        static let keepName = "keepName"
    }
    
    let userMain = UserDefaults.standard
    //user variables
    let userToken = UserData().defaults.string(forKey: "userToken")
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUserData()
    }
    
    @IBAction func changePicturePressed(_ sender: UIButton) {
        // open pictures and chose one
    }// end of changePicture
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        keepNames()
        // call the callUpdate method
        // pop out that says saved!
    }// end of donePressed
    
    
    
    
    func getUserData() {
        let callURL = baseURL + "/php/getUser.php"
        
        let params : [String : Any] = ["token" : userToken!]
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                self.updateUI(userJSON: userJSON)
            } else {
                print("there was an error getting the data please try again")
                print("this is the error code: \(response.result.error!)")
            }
        }// end of the closure
    }// end of getUserData
    
    
    func updateUI(userJSON : JSON) {
        firstNameTextField.text = userJSON["result"]["FirstName"].string
        lastNameTextField.text = userJSON["result"]["LastName"].string
        
    }
    
    func keepNames() {
        userMain.set(firstNameTextField!, forKey: Data.keepName)
        userMain.set(lastNameTextField!, forKey: Data.keepName)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// end of UserProfileViewController
