//
//  TroubleLoginViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-12-27.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class TroubleLoginViewController: UIViewController {
    
    //Variables
    @IBOutlet weak var loginLinkButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var infoTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        loginLinkButton.layer.cornerRadius = 12
        loginLinkButton.clipsToBounds = true
        loginLinkButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        loginLinkButton.layer.borderWidth = 1
        
        createAccountButton.layer.cornerRadius = 12
        createAccountButton.clipsToBounds = true
        createAccountButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        createAccountButton.layer.borderWidth = 1
    }//end of viewDidLoad
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            loginLinkButton.layer.borderColor = UIColor.secondaryLabel.cgColor
            createAccountButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        }//end of if
    }//end of traitCollectionDidChamge
    
    @IBAction func loginLinkPressed(_ sender: UIButton) {
        //reference to call function
    }//end of loginLinkPressed
    
    
    @IBAction func returnToLoginPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }//end of returnToLoginPressed
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of TroubleLoginViewController
