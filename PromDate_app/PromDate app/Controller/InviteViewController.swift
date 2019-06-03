//
//  InviteViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-26.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }//end of viewDidLoad
    
    @IBAction func invitePressed(_ sender: Any) {
        let messageToShare = "Checkout this awesome app PromDate!"
        //let urlToShare = NSURL(string: "https://digitera.agency")
        let urlToShare = NSURL(string: "http://promdate.app")
        
        let objectsToShare : [Any] = [messageToShare, urlToShare!]
        
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
        
    }//end of invitePressed
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of InviteViewController
