//
//  LogInViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-04.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    // variables
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
    let baseURL : String = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var token : String = ""
    let userData = UserData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.textContentType = .username
        passwordTextField.textContentType = .password
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        logInButton.layer.cornerRadius = 10
        logInButton.clipsToBounds = true
        
        if let fetchToken = userData.defaults.string(forKey: "userToken") {
            token = fetchToken
        }//end of if/let
        
        checkIfLoggedIn()
    }// end of viewDidLoad
    
    @IBAction func logInPressed(_ sender: UIButton) {
        print("log in pressed")
        let callURL = baseURL + "/php/authenticate.php"
        let email : String = emailTextField.text!
        let password :String = passwordTextField.text!
        print(email)
        print(password)
        let params : [String : String] = ["email" : email, "password" : password ]
        callLogIn(url: callURL, parameters: params)
    }// end of logInPressed
    
    func callLogIn(url : String, parameters : [String : String]) {
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                let authJSON : JSON = JSON(response.result.value!)
                print(authJSON)
                self.verifyStatus(json: authJSON)
            } else {
                print("error \(response.result.error!)")
                print("App failed to reach server")
                self.networkingAlertControllers(alertTitle: "Networking Error", alertMessage: "The app failed to reach the server. Please check your network connection.")
            }// end of if/else
        }// end of the request
    }// end of callLogIn
    
    func verifyStatus(json : JSON){
        let status = json["status"]
        if status == 200 {
            //segue towards mainfeed
            token = json["result"].stringValue
            //We add the token to the userDefaults
            userData.defaults.set(token, forKey: "userToken")
            userData.defaults.set(true, forKey: "isLoggedIn")
            goToMainFeed()
        } else {
            print("an error occured while loging in")
            let errorMessage = json["result"].string!
            let alert = UIAlertController(title: "Log In Error", message: "\(errorMessage), Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }// end of if/else
    }// end of verifyStatus
    
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMainFeed" {
            
        }// end of if
    }// end of prepareForSegue
    
    func goToMainFeed(){
        passwordTextField.text = nil
        emailTextField.text = nil
        performSegue(withIdentifier: "goToMainFeed", sender: self)
    }// end of goToMainFeed
    
    func checkIfLoggedIn() {
        let boolLogIn = userData.defaults.bool(forKey: "isLoggedIn")
        // if the "isLoggedIn" var in the userDefaukts is true the app direcly goes to the main feed otherwise the user has to login normally
        if boolLogIn == true {
            print("User is logged in")
            
            // call regen token
            callRegenToken()
        } else {
            print("user is not logged in")
        }//end of if/else
    }// end of checkIfLoggedIn
    
    func callRegenToken() {
        let callURL = baseURL + "/php/regenToken.php"
        let params : [String : Any] = ["token" : UserData().defaults.string(forKey: "userToken")!]
        
        
        Alamofire.request(callURL, method: .post, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                print("regen token was sucessfull")
                let regenJSON : JSON = JSON(response.result.value!)
                let regenToken = regenJSON["result"].string
                print("userToken(regen): \(regenToken!)")
                self.verifyStatus(json: regenJSON)
//                UserData().defaults.set(regenToken, forKey: "userToken")
//                print("goToMainFeed")
//                self.goToMainFeed()
            } else {
                print("there was an error getting the Data")
                self.networkingAlertControllers(alertTitle: "Error getting Data", alertMessage: "There was an error getting the Data, please check your network connection and try again")
            }//end of if/else
        }//end of request
    }//end of callRegenToken
    
    
    func networkingAlertControllers(alertTitle : String, alertMessage : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }//end of networkingAlertControllers

    
}//end of LogInViewController
