//
//  ApparelRegistryViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-25.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class ApparelRegistryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // varriables
    @IBOutlet weak var brandPickerView: UIPickerView!
    @IBOutlet weak var modelNumberTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    let apparelBrandsArray = ["Dress Brand", "Dress Brand", "Another Dress Brand", "Some Dress Brand", "Starfleet Uniforms", "Star Wars Outfiters", "Apple Merch", "Every Youtuber's Merch Ever", "Top Marks", "Every other Company"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        brandPickerView.delegate = self
        brandPickerView.dataSource = self
        //we set ourselves as delegates
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        //round the search button's corners
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
    }//end of viewDidLoad
    
    
    
    @IBAction func searchPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToSearchFeed", sender: self)
    }//end of searchPressed
    
    //MARK: - PickerView delegate and DataSource functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }//end of numberOfComponents
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return apparelBrandsArray.count
    }//end of numberOfRowsInComponent
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return apparelBrandsArray[row]
    }//end of titleForRow
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearchFeed" {
            
        }//end of if
    }//end of prepareForSegue
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of ApparelRegisteryViewController
