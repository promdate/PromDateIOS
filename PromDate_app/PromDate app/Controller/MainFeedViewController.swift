//
//  MainFeedViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-09.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //variables
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var feedSegmentedControl: UISegmentedControl!
    
    var singlesSelected : Bool = false
    let baseURL : String = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var feedReusableCell = ""
    var feedJSON : JSON!
    var selectedUserID = ""
    
    
    
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
        singlesSelected = false
        
        // call some kind of function that loads singles data --> dataLoaded() or loadData()
        
        configureTableView()
    }
    
    
    @IBAction func feedIndexChanged(_ sender: UISegmentedControl) {
        switch feedSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Couples Selected")
            // set singles as selected
            singlesSelected = false
            feedTableView.reloadData()
        case 1:
            print("Singles Selected")
            // set couples as selected
            singlesSelected = true
            feedTableView.reloadData()
        case 3:
            print("wish selected")
            feedTableView.reloadData()
        default:
            print("default selected")
        }// end of switch
        feedTableView.reloadData()
    }// end of feedIndexChanges
    
    // MARK: - Declare cellForRowAT
    // declare cellForRowAt func
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if that changes the custom cell depending on what segment is choosen ( Singles or couples)
        //let messageArray = ["test 12","Hello world", "Live long and prosper", "Hamza Khan", "Logan Mack"]
        getFeed()
        if singlesSelected == true {
            // initialization of cell which is the var with the custom cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "singlesCell", for: indexPath) as! SinglesTableViewCell
//            cell.nameLabel.text = messageArray[indexPath.row]
//            cell.avatarImageView.image = UIImage(named: "avatar_placeholder")
            cell.nameLabel.text = feedJSON["result"]["unmatched"][indexPath.row]["FirstName"].string
            cell.gradeLabel.text = feedJSON["result"]["unmatched"][indexPath.row]["Grade"].string
            cell.bioLabel.text = feedJSON["result"]["unmatched"][indexPath.row]["Biography"].string
            cell.avatarImageView.image = UIImage(named: "avatar_placeholder")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "couplesCell", for: indexPath) as! CouplesTableViewCell
            let couplesArray = ["El & Sam", "Lucas & Max", "Mike & Eleven", "t'pol & tripp", "Picard & Crusher", "El & Sam", "El & Sam", "El & Sam", "El & Sam", "El & Sam", "El & Sam"]
            cell.couplesNamesLabel.text = couplesArray[indexPath.row]
            cell.firstAvatarImageView.image = UIImage(named: "avatar_placeholder")
            cell.seccondAvatarImageView.image = UIImage(named: "avatar_placeholder")
            return cell
        }// end of if/else
    }// end of cellForRowAt
    
    //MARK: - Declare numbersOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }// end of numbersOfRowsInSection
    
    //MARK: - didSelectRowAt function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if singlesSelected == true {
            selectedUserID = feedJSON["result"]["unmatched"][indexPath.row]["ID"].string!
            performSegue(withIdentifier: "goToSelectedUser", sender: self)
        }// end of if
        
        if singlesSelected == false {
            performSegue(withIdentifier: "goToSelectedCouple", sender: self)
        }// end of if
    }// end of didSelectRowAt
    
    //MARK: - getFeedCall function
    func getFeed() {
        let callURL = baseURL + "/php/search.php"
        let params : [String : Any] = ["token" : userToken!, "max-users" : 11]
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                self.feedJSON = JSON(response.result.value!)
                
                print(self.feedJSON)
            } else {
                print("Failed to get Data : there was an error during the request")
                print("error: \(response.result.error!)")
            }//end of if/else
        }// end of request
    }// end of getFeed
    
    //MARK: - Declare configureTableView
    //configureTableView is a func which allows the tableViewCells to have the good rowHeight so that the custom cells will fit properly
    func configureTableView() {
        feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.estimatedRowHeight = 60.0
    }//end of configureTableView
    
    
    //MARK: - PrepareForSegue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectedUser" {
            let destinationVC = segue.destination as! SinglesUserProfileViewController
            destinationVC.userID = selectedUserID
        }//end of if
    }//end of prepare for segue
    
   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// end of MainFeedViewController
