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
    
    
    let userToken = UserData().defaults.string(forKey: "userToken")
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    let userMain = UserDefaults.standard
    
    struct Data {
        static let keepFirstName = "keepFirstName"
        static let keepLastName = "keepLastName"
        static let keepTwitterhandle = "keeptTwitterhandle"
        static let keepSnapchateHandle = "keepSnapchatHandle"
        static let keepInstagramHandle = "keepInstagramHandle"
        static let keepBio = "keepBio"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserData()
        checkedForSavedNames()
        
    }
    
    @IBAction func changePicturePressed(_ sender: UIButton) {
        
        // open pictures and chose one
    }// end of changePicture
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let firstName : String = firstNameTextField.text!
        let lastName : String = lastNameTextField.text!
        let instagram : String = instagramHandleTextField.text!
        let twitter : String = twitterHandleTextField.text!
        let snap : String = snapchatHandleTextField.text!
        let bio : String = bioTextField.text!
        print(firstName)
        print(lastName)
        print(bio)
        print(instagram)
        print(snap)
        print(twitter)
        saveNames()
        
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
    func saveNames() {
        userMain.set(firstNameTextField.text!, forKey: Data.keepFirstName)
        userMain.set(lastNameTextField.text!, forKey: Data.keepLastName)
        userMain.set(instagramHandleTextField.text!, forKey: Data.keepInstagramHandle)
        userMain.set(twitterHandleTextField.text!, forKey: Data.keepTwitterhandle)
        userMain.set(snapchatHandleTextField.text!, forKey: Data.keepSnapchateHandle)
        userMain.set(bioTextField.text!, forKey: Data.keepBio)
    }
   

    func checkedForSavedNames() {
        let firstName = userMain.value(forKey: Data.keepFirstName) as? String ?? ""
        let lastName = userMain.value(forKey: Data.keepLastName) as? String ?? ""
        
        let instagram = userMain.value(forKey: Data.keepInstagramHandle) as? String ?? ""
        let twitter = userMain.value(forKey: Data.keepTwitterhandle) as? String ?? ""
        let snap = userMain.value(forKey: Data.keepSnapchateHandle) as? String ?? ""
        let bio = userMain.value(forKey: Data.keepBio) as? String ?? ""
        
        firstNameTextField.text = firstName
        lastNameTextField.text = lastName
        
        instagramHandleTextField.text = instagram
        twitterHandleTextField.text = twitter
        snapchatHandleTextField.text = snap
        twitterHandleTextField.text = twitter
        bioTextField.text = bio
    }
    /*
     //MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// end of UserProfileViewController
