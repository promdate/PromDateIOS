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
    var token = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewControllerTapped))
//        emailTextField.addGestureRecognizer(tapGesture)
//        passwordTextField.addGestureRecognizer(tapGesture)
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
            }else {
                print("error \(response.result.error!)")
            }// end of if/else
        }// fin de la requette
    }// end of callLogIn
    
    func verifyStatus(json : JSON){
        let status = json["status"]
        if status == 200 {
            //segue towards mainfeed
             token = json["result"].stringValue
            performSegue(withIdentifier: "goToMainFeed", sender: self)
        } else {
            print("an error occured while loging in")
        }// end of if/else
    }// end of verifyStatus
    
//    @objc func viewControllerTapped()  {
//        emailTextField.endEditing(true)
//        passwordTextField.endEditing(true)
//    }// end of viewControllerTapped


     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMainFeed" {
            //         Get the new view controller using segue.destination.
            let destinationVC = segue.destination as! MainFeedViewController
            destinationVC.userToken = token
            //         Pass the selected object to the new view controller.
        }// end of if

    }// end of prepareForSegue

}//end of LogInViewController