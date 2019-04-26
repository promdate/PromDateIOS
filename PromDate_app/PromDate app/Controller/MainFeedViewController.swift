//
//  MainFeedViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-09.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //variables
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var feedSegmentedControl: UISegmentedControl!
    
    var singlesSelected : Bool = true
    var feedReusableCell = ""
 
    
    //setting self as delegate and datasource of feedTableView
    
    
    
    var userToken = UserData().defaults.string(forKey: "userToken")

    override func viewDidLoad() {
        super.viewDidLoad()
        //setting self as delegate and datasource of feedTableView
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        // register custom table view Cells
        feedTableView.register(UINib(nibName: "SinglesTableViewCell", bundle: nil), forCellReuseIdentifier: "singlesCell")
        feedTableView.register(UINib(nibName: "CouplesTableViewCell", bundle: nil), forCellReuseIdentifier: "couplesCell")
        
        //giving basic value of true to singlesSelected so that it is the default tab shown when loading this view
        singlesSelected = true
        
        // call some kind of function that loads singles data --> dataLoaded() or loadData()
        
        configureTableView()
    }
    
    
    @IBAction func feedIndexChanged(_ sender: UISegmentedControl) {
        switch feedSegmentedControl.selectedSegmentIndex {
        case 0:
            print("singles Selected")
            // set singles as selected
            singlesSelected = true
        case 1:
            print("Couples Selected")
            // set couples as selected
            singlesSelected = false
        default:
            print("default selected")
        }// end of switch
        feedTableView.reloadData()
    }// end of feedIndexChanges
    
    // MARK: - Declare cellForRowAT
    // declare cellForRowAt func
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if that changes the custom cell depending on what segment is choosen ( Singles or couples)
        let messageArray = ["test 12","Hello world", "Live long and prosper"]
        if singlesSelected == true {
            // initialization of cell which is the var with the custom cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "singlesCell", for: indexPath) as! SinglesTableViewCell
            cell.nameLabel.text = messageArray[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "couplesCell", for: indexPath) as! CouplesTableViewCell
            let couplesArray = ["El & Sam", "Lucas & Max", "Mike & Eleven"]
            cell.couplesNamesLabel.text = couplesArray[indexPath.row]
            return cell
        }// end of if/else
    }// end of cellForRowAt
    
    //MARK: - Declare numbersOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }// end of numbersOfRowsInSection
    
    //MARK: - Declare configureTableView
    //configureTableView is a func which allows the tableViewCells to have the good rowHeight so that the custom cells will fit properly
    func configureTableView() {
        feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.estimatedRowHeight = 60.0
    }
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// end of MainFeedViewController
