//
//  SchoolChoiceViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-06-13.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class SchoolChoiceViewController: UIViewController {
    //variables
    @IBOutlet weak var countryButton: UIButton!
    @IBOutlet weak var provinceButton: UIButton!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var schoolButton: UIButton!
    @IBOutlet weak var locationPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        provinceButton.isEnabled = false
        provinceButton.isHidden = true
        cityButton.isHidden = true
        cityButton.isEnabled = false
        schoolButton.isEnabled = false
        schoolButton.isHidden = true
        locationPicker.isHidden = true
    }//end of viewDidLoad
    
    @IBAction func setCountryPressed(_ sender: UIButton) {
    }//end of setCountryPressed
    
    @IBAction func setProvincePressed(_ sender: UIButton) {
    }
    
    @IBAction func setCityPressed(_ sender: Any) {
    }//end of setCityPressed
    
    @IBAction func setSchoolPressed(_ sender: UIButton) {
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
