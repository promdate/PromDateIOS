//
//  UserProfileViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-25.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import Photos

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //variables
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextView!
    @IBOutlet weak var twitterHandleTextField: UITextField!
    @IBOutlet weak var snapchatHandleTextField: UITextField!
    @IBOutlet weak var instagramHandleTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var unmatchButton: UIButton!
    @IBOutlet weak var partnerButton: UIButton!
    @IBOutlet weak var partnerNameLabel: UILabel!
    
    
    let userToken = UserData().defaults.string(forKey: "userToken")
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    let userMain = UserDefaults.standard
    var imagePicker : UIImagePickerController!
    var profilePictureChanged = false
    //let placeholderPic = UIImage(named: "avatar_placeholder")
    var userProfilePic : UIImage!
    var partnerID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // setup white back button
        
        //we setup borders and other visual stuff
        bioTextField.layer.borderWidth = 1
        bioTextField.layer.borderColor = UIColor.black.cgColor
        //visual stuff so that the profile pic is rounded
        userAvatar.layer.borderWidth = 1
        userAvatar.layer.masksToBounds = false
        userAvatar.layer.borderColor = UIColor.black.cgColor
        userAvatar.layer.cornerRadius = userAvatar.frame.height/2
        userAvatar.clipsToBounds = true 
        
        //we set the unmatch button to hidden/is hilighted
        //unmatchButton.isHidden = true
        unmatchButton.isHighlighted = true
        unmatchButton.isEnabled = false
        partnerButton.isHidden = true
        partnerButton.isEnabled = false
        partnerNameLabel.isHidden = true
        //we make sure that profile pic changed is false
        profilePictureChanged = false
        
        getUserData()
        
        //block which permits to click away when using keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }//end of viewDidLoad
    
    @IBAction func changePicturePressed(_ sender: UIButton) {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        
        let alert = UIAlertController(title: "Picture Source", message: nil, preferredStyle: .actionSheet)
        let takePicture = UIAlertAction(title: "Take Picture", style: .default) { (UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.showsCameraControls = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }//end of takePicture
        let choosePicture = UIAlertAction(title: "Pick from Library", style: .default) { (UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }// end of chosePicture
        
        alert.addAction(takePicture)
        alert.addAction(choosePicture)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }// end of changePicture
    
    
    @IBAction func unmatchPressed(_ sender: Any) {
        let callURL = baseURL + "/php/match.php"
        let params : [String : Any] = ["token" : userToken!, "partner-id" : partnerID, "action" : 1]
        
        Alamofire.request(callURL, method: .post, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                print("sucess got data")
                let unmatchJSON : JSON = JSON(response.result.value!)
                self.verifyStatus(statusJSON: unmatchJSON, alertTitle: "Unmatch", alertMessage: "Unmatching from your partner")
                print("sucessfully unmatched from partner")
                print(response.result.value!)
                //self.unmatchButton.isEnabled = false
                
            } else {
                print("there was an error getting the data")
                print("this is the error code: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of unmatchPressed
    
    @IBAction func partnerNamePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSelectedUser", sender: self)
    }//end of partnerNamePressed
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //imagePicker.dismiss(animated: true, completion: nil)
        //userAvatar.image = info[.originalImage] as? UIImage
        userAvatar.image = info[.editedImage] as? UIImage
        userProfilePic = info[.editedImage] as? UIImage
        
        profilePictureChanged = true
        imagePicker.dismiss(animated: true, completion: nil)
    }//end of imagePickerController
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        let callURL = baseURL + "/php/updateUser.php"
        let params : [String : Any] = ["token" : userToken!, "first-name": firstNameTextField.text!, "social-twitter" : twitterHandleTextField.text!, "bio" : bioTextField.text!, "social-snapchat" : snapchatHandleTextField.text!, "social-instagram" : snapchatHandleTextField.text!, "last-name" : lastNameTextField.text!]
        
        Alamofire.request(callURL, method: .post, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                print(response.result.value!)
                let responseJSON = JSON(response.result.value!)
                if self.profilePictureChanged == true {
                    self.uploadUserImage()
                } else {
                    self.verifyStatus(statusJSON: responseJSON, alertTitle: "Update", alertMessage: "Updating your user Data")
                }//end of if/else
                
            } else {
                print("there was an error getting the data please try again")
                print("networking error")
                print("this is the error code: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }// end of donePressed
    
    func verifyStatus(statusJSON : JSON, alertTitle : String, alertMessage : String) {
        if statusJSON["status"] == 200 {
            let alert = UIAlertController(title: "\(alertTitle) Sucessfull", message: "\(alertMessage) was sucessfull!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                if alertTitle == "Unmatch" {
                    print("in side if alertTitle")
                    self.unmatchButton.isHighlighted = true
                    self.unmatchButton.isEnabled = false
                }//end of if
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "\(alertTitle) Unsucessfull", message: "There was an error \(alertMessage.lowercased()), please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }//end of if/else
    }//end of verifyStatus
   
    
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
            }//end of if/else
        }// end of the closure
    }// end of getUserData
    
    func updateUI(userJSON : JSON) {
        print("updateUI")
        // we get the data from the userJSON and load it in the appropriate places
        //userAvatar.image = userJSON["result"]["user"]["ProfilePicture"]
        firstNameTextField.text = userJSON["result"]["user"]["FirstName"].string
        lastNameTextField.text = userJSON["result"]["user"]["LastName"].string
        bioTextField.text = userJSON["result"]["user"]["Biography"].string
        twitterHandleTextField.text = userJSON["result"]["user"]["SocialTwitter"].string
        snapchatHandleTextField.text = userJSON["result"]["user"]["SocialSnapchat"].string
        instagramHandleTextField.text = userJSON["result"]["user"]["SocialInstagram"].string
        
        //we load the profile pic
        let profilePicURL = userJSON["result"]["user"]["ProfilePicture"].string
        loadUserPicture(imageURL: profilePicURL!)
        
        //we check to see if the unmatch button should be shown
        if userJSON["result"]["user"]["Matched"] == "1" {
            //we set the partnerID var to a value and the button is hidden to false
            partnerID = userJSON["result"]["user"]["PartnerID"].string!
            //unmatchButton.isHidden = false
            unmatchButton.isHighlighted = false
            unmatchButton.isEnabled = true
            partnerNameLabel.isHidden = false
            partnerButton.isHidden = false
            partnerButton.isEnabled = true
            let partnerName = "\(userJSON["result"]["partner"]["FirstName"]) \(userJSON["result"]["partner"]["LastName"])"
            partnerButton.setTitle("\(partnerName)", for: .normal)
        } else {
            //we set the button to is  hidden to true
            //unmatchButton.isHidden = true
            unmatchButton.isHighlighted = true
            unmatchButton.isEnabled = false
        }//end of if/else
    }//end of updateUI
  
    func loadUserPicture(imageURL : String) {
        var profilePicURL = imageURL
        
        let userSlashIndex = profilePicURL.startIndex..<profilePicURL.index(profilePicURL.startIndex, offsetBy: 2)
        if profilePicURL[userSlashIndex] == "\\/" {
            profilePicURL.removeSubrange(userSlashIndex)
        }//end of if
        
        let callURL = baseURL + "/\(profilePicURL)"
        
        //alamofire request to load the userAvatar image
        Alamofire.request(callURL).responseImage {
            response in
            if response.result.isSuccess {
                let profileImage = response.result.value
                self.userAvatar.image = profileImage
            } else {
                print("there was an error getting the photo")
                print("error: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of loadUserPicture
    
    func uploadUserImage() {
        let imageToUpload = userProfilePic
        //let imageToUpload = UIImage(named: "alarm-100")
        print(imageToUpload!)
        //let imageData = UIImage.jpegData(userAvatar.image!)
        //let otherImageData = imageToUpload!.pngData()!
        let otherImageData = imageToUpload!.jpegData(compressionQuality: 1)!
        let params : [String : String] = ["token" : userToken!]
        let callURL = baseURL + "/php/updateUser.php"
        
        
        Alamofire.upload(multipartFormData: { formData in
            print("at start of upload call")
            for (key, value) in params {
                formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }//end of for/loop
            formData.append(otherImageData, withName: "img", fileName: "img.png", mimeType: "img/png")
            
        }, to: callURL, method: .post) { (response) in
            switch response {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })//end of closure
                upload.responseJSON(completionHandler: { (response) in
                    print(response)
                    print("Request sent to server: \(response.request!)")
                    print(response.result)
                    let responseJSON = JSON(response.result.value!)
                    self.verifyStatus(statusJSON: responseJSON, alertTitle: "Updating", alertMessage: "Updating your user data")
                })//end of closure
            case .failure(let encodingError):
                print(encodingError)
            }//end of switch
        }//end of closure/ end of upload
    }//end of uploadUserImage
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedUser" {
            let destinationVC = segue.destination as! SinglesUserProfileViewController
            destinationVC.userID = partnerID
        }//end of if
    }//end of prepareForSegue
    /*
     //MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// end of UserProfileViewController
