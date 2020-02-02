//
//  ChangePasswordViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-25.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    // variables
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        changePasswordButton.layer.cornerRadius = 10
        changePasswordButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func changePasswordPressed(_ sender: Any) {
        verifyPassword()
    }// end of changePasswordPressed
    
    
    func verifyPassword() {
        if newPasswordTextField.text != confirmNewPasswordTextField.text {
            warningLabel.isHidden = false
        } else {
            warningLabel.isHidden = true
        }// end of if/else
        
    }// end of verifyPassword
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
