//
//  SignUpViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-04.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    // variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    let baseURL : String = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        warningLabel.isHidden = true
    }// end of viewDidLoad
    

    @IBAction func signUpPressed(_ sender: UIButton) {
        verifyPassword()
        
    }// end of signUpPressed
    
    func callSignUp(url : String, parameters : [String : Any]) {
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("sucess")
                let signUpJSON : JSON = JSON(response.result.value!)
                self.verifyStatus(json: signUpJSON)
                print(signUpJSON)
            } else {
                print("error \(response.result.error!)")
            }// end of if/else
        }// end of call
        
    }//end of callSignUp
    
    func prepareForCall() {
        let callURL = baseURL + "/php/register.php"
        print(callURL)
        let email : String = emailTextField.text!
        let password : String = passwordTextField.text!
        let confirmPassword : String = confirmPasswordTextField.text!
        let firstName : String = firstNameTextField.text!
        let lastName : String = lastNameTextField.text!
        print(email)
        print(password)
        print(confirmPassword)
        print(firstName)
        print(lastName)
        let params : [String:Any] = ["email" : email, "password" : password, "password-retype" : confirmPassword, "first-name" : firstName, "last-name" : lastName, "school-id" : 1, "grade" : 11]
        callSignUp(url: callURL, parameters: params)
    }// end of prepareForCall
    
    func verifyPassword() {
        if passwordTextField.text != confirmPasswordTextField.text {
            warningLabel.isHidden = false
        } else {
            warningLabel.isHidden = true
            prepareForCall()
        }// end of if/else
    }// end of verifyPassword
    
    func verifyStatus(json : JSON) {
        let status = json["status"]
        if status == 200 {
            //segue towards main feed
            let alert = UIAlertController(title: "Verify Email required", message: "In order to contiue the sign up process please accept the confirmation email that has been sent", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else {
            print("error occured while trying to sign up")
            let alert = UIAlertController(title: "An error occured", message: "\(json["result"]) Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }//end of if/else
    }// end of verifyStatus
    
    @IBAction func loginPressed(_ sender: UIButton) {
        //dismises so that user is brought back to login page
        self.dismiss(animated: true, completion: nil)
        
    }// end of loginPressed

}// end of SignUpViewController
