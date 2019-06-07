//
//  ApparelProfileViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-06-07.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class ApparelProfileViewController: UIViewController {
    //variables
    @IBOutlet weak var apparelWebURLButton: UIButton!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var modelNumberLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var numberOfTimesChosenLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }//end of viewDidLoad
    
    @IBAction func apparelURLPressed(_ sender: UIButton) {
        if let apparelURL = URL(string: "http://promdate.app") {
            UIApplication.shared.open(apparelURL)
        }//end of iflet
        
//        if let apparelOtherURL = NSURL(string: "http://promdate.app") {
//
//        }//end of iflet
    }//end of apparelURLPressed
    
    @IBAction func pickDressPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Apparel Registered", message: "This apparel has been registered with your account, other users can now see that you will wear it!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }//end of pickDressPressed
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of ApparelProfileViewController
