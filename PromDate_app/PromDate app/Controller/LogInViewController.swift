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
    
    let baseURL : String = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var token : String = ""
    let userData = UserData()
    
//    struct Data {                                           //creating a structure for storing strings
//        static let keepEmail = "keepEmail"                  //string
//        static let keepPassword = "keepPassword"            //string
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        //token = defaults.data(forKey: "userToken")
        print("token avant aller le chercher dans defaults : \(token)")
        //        if let fetchToken = defaults.string(forKey: "userToken") {
        //            token = fetchToken
        //        }
        if let fetchToken = userData.defaults.string(forKey: "userToken") {
            token = fetchToken
        }
        
        print("token appres avoir ete le chercher\(token)")
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewControllerTapped))
        //        emailTextField.addGestureRecognizer(tapGesture)
        //        passwordTextField.addGestureRecognizer(tapGesture)
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
        remainLoggedIn()
    }// end of logInPressed
    
    func callLogIn(url : String, parameters : [String : String]) {
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                let authJSON : JSON = JSON(response.result.value!)
                print(authJSON)
                self.verifyStatus(json: authJSON)
            }else {
                print("error \(response.result.error!)")
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
            //performSegue(withIdentifier: "goToMainFeed", sender: self)
        } else {
            print("an error occured while loging in")
        }// end of if/else
    }// end of verifyStatus
    
    //    @objc func viewControllerTapped()  {
    //        emailTextField.endEditing(true)
    //        passwordTextField.endEditing(true)
    //    }// end of viewControllerTapped
    
    
    //MARK: - Navigation
    
//    In a storyboard-based application, you will often want to do a little preparation before navigation
//        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToMainFeed" {
            }// end of if
        }// end of prepareForSegue
    
    func goToMainFeed(){
        passwordTextField.text = nil
        emailTextField.text = nil
        performSegue(withIdentifier: "goToMainFeed", sender: self)
    }// end of goToMainFeed
    
    func remainLoggedIn() {
        userData.defaults.set(emailTextField.text!, forKey: "keepEmail")                     // creates a saved section for emailTextField in userMain
        userData.defaults.set(passwordTextField.text!, forKey: "keepPassword")              //creates a saved section for passwordTextField in userMain
        
    }
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
        
//        let email = userData.defaults.value(forKey: "keepEmail") as? String ?? ""          //retrieves email and displays it on screen in userMain
//        let password = userData.defaults.value(forKey: "keepPassword") as? String ?? ""    // retrieves password and displays it on screen userMain
//
//        emailTextField.text = email                                                //declaring that emailTextField should be doing the retrieve func
//        passwordTextField.text = password                                         //declaring that passwordTextField should be doing the retrieve func
        
    }// end of checkIfLoggedIn
    
    func callRegenToken() {
        let callURL = baseURL + "/php/regenToken.php"
        let params : [String : Any] = ["token" : UserData().defaults.string(forKey: "userToken")!]
        
        
        Alamofire.request(callURL, method: .post, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                print("regen token was sucessfull")
                let regenJSON : JSON = JSON(response.result.value!)
                let regenToken = regenJSON["result"].string
                UserData().defaults.set(regenToken, forKey: "userToken")
                print("goToMainFeed")
                self.goToMainFeed()
            } else {
                print("there was an error getting the Data")
            }//end of if/else
        }//end of request
    }//end of callRegenToken

    
}//end of LogInViewController
