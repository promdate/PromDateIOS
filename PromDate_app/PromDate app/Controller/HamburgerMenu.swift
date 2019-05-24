//
//  HamburgerMenu.swift
//  PromDate app
//
//  Created by Hamza Khan on 2019-05-24.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class HamburgerMenu: UIViewController {

    @IBOutlet weak var leadingC: NSLayoutConstraint!
    
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    
    @IBOutlet weak var ubeView: UIView!
    var hamburgerMenuIsPressed = false
    
    @IBAction func hamburgerMenuPressed(_ sender: Any) {
        if hamburgerMenuIsPressed {
            leadingC.constant = 150
            trailingC.constant = -150
        
            hamburgerMenuIsPressed = true
        }else{
            leadingC.constant = 0
            trailingC.constant = 0
            
            hamburgerMenuIsPressed = false
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
        print("the animation is complete")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

 

}
