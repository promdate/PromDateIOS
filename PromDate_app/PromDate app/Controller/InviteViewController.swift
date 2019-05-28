//
//  InviteViewController.swift
//  PromDate app
//
//  Created by Hamza Khan on 2019-05-28.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class InviteViewController: MFMessageComposeViewController,UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func invite(_ sender: Any) {
        if !InviteViewController.canSendText() {
            print("SMS services are not available")
        }
       
}
}
