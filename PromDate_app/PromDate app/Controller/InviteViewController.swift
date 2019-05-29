//
//  InviteViewController.swift
//  PromDate app
//
//  Created by Hamza Khan on 2019-05-29.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import MessageUI

class InviteViewController: UIViewController, MFMailComposeViewControllerDelegate{

  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func invite(_ sender: Any) {
     /*   let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = ["Enter tel-nr"]
        messageVC.messageComposeDelegate = self as! MFMessageComposeViewControllerDelegate
        
        self.present(messageVC, animated: true, completion: nil)*/
        
    }
    /*func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }

*/}
