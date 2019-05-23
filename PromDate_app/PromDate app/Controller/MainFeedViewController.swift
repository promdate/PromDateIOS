//
//  MainFeedViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-09.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {

    
    //variables
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var feedSegmentedControl: UISegmentedControl!
    
    var singlesSelected : Bool = false
    let baseURL : String = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var feedReusableCell = ""
    var feedJSON : JSON!
    var feedImages : Image!
    var feedArray : [JSON]!
    var selectedUserID = ""
    let numberUserLoaded = 15
    var numberOfTimesLoaded = 0
    var userToken = UserData().defaults.string(forKey: "userToken")
    var feedOffset = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        //setting self as delegate and datasource of feedTableView
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.prefetchDataSource = self
        
        // register custom table view Cells
        feedTableView.register(UINib(nibName: "SinglesTableViewCell", bundle: nil), forCellReuseIdentifier: "singlesCell")
        feedTableView.register(UINib(nibName: "CouplesTableViewCell", bundle: nil), forCellReuseIdentifier: "couplesCell")
        
        //giving basic value of true to singlesSelected so that it is the default tab shown when loading this view
        singlesSelected = false
        
        // call some kind of function that loads singles data --> dataLoaded() or loadData()
        configureTableView()
        
        //we make sure feedoffset is = to 0
        feedOffset = 0
        //get user data
        getFeed()
        
    }//end of viewDidLoad
    
    
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
    
    //MARK: - prefetchRowsAt
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        numberOfTimesLoaded += 1
//        print(numberOfTimesLoaded)
//        feedOffset += numberUserLoaded
//        getFeed()
        
        numberOfTimesLoaded += 1
        print(numberOfTimesLoaded)
        feedOffset += numberUserLoaded
        //getFeed()
        getRestOfFeed()
        
    }//end of prefetchRowsAt
    
    // MARK: - Declare cellForRowAT
    // declare cellForRowAt func
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if that changes the custom cell depending on what segment is choosen ( Singles or couples)
        //let messageArray = ["test 12","Hello world", "Live long and prosper", "Hamza Khan", "Logan Mack"]
        if singlesSelected == true {
            print("singlesSelected")
//            let imageURL = feedJSON["result"]["unmatched"][indexPath.row]["ProfilePicture"].string
//            loadUserPicture(pictureURL: imageURL!)
            
            // initialization of cell which is the var with the custom cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "singlesCell", for: indexPath) as! SinglesTableViewCell
            //cell.nameLabel.text = feedJSON["result"]["single"][indexPath.row]["FirstName"].string
            //cell.gradeLabel.text = "Grade: \(feedJSON["result"]["single"][indexPath.row]["Grade"])"
            //cell.bioLabel.text = feedJSON["result"]["single"][indexPath.row]["Biography"].string
            cell.avatarImageView.image = UIImage(named: "avatar_placeholder")
            
            cell.nameLabel.text = feedArray[numberOfTimesLoaded]["result"]["single"][indexPath.row]["FirstName"].string
            cell.gradeLabel.text = "Grade: \(feedArray[numberOfTimesLoaded]["result"]["single"][indexPath.row]["Grade"])"
            //cell.bioLabel.text = feedArray[numberOfTimesLoaded]["result"]["single"][indexPath.row]["Biography"].string
            //let imageURL = feedJSON["result"]["unmatched"][indexPath.row]["ProfilePicture"].string
            //cell.avatarImageView.image = loadUserPicture(pictureURL: imageURL!)
            //cell.avatarImageView.image = feedImages
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "couplesCell", for: indexPath) as! CouplesTableViewCell
            cell.couplesNamesLabel.text = "\(feedJSON["result"]["couple"][indexPath.row][0]["FirstName"]) & \(feedJSON["result"]["couple"][indexPath.row][1]["FirstName"])"
            //let couplesArray = ["El & Sam", "Lucas & Max", "Mike & Eleven", "t'pol & tripp", "Picard & Crusher", "El & Sam", "El & Sam", "El & Sam", "El & Sam", "El & Sam", "El & Sam"]
            //cell.couplesNamesLabel.text = couplesArray[indexPath.row]
            cell.firstAvatarImageView.image = UIImage(named: "avatar_placeholder")
            cell.seccondAvatarImageView.image = UIImage(named: "avatar_placeholder")
            return cell
        }// end of if/else
    }// end of cellForRowAt
    
    //MARK: - Declare numbersOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 11
        print("entered numbersOfRowsInSection")
        print(feedJSON)
        if feedJSON != nil {
            if singlesSelected == true {
                return feedJSON["result"]["single"].count
            } else {
                return feedJSON["result"]["couple"].count
            }//end of if/else
        } else {
            return 0
        }
    }// end of numbersOfRowsInSection
    
    //MARK: - didSelectRowAt function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if singlesSelected == true {
            selectedUserID = feedJSON["result"]["single"][indexPath.row]["ID"].string!
            performSegue(withIdentifier: "goToSelectedUser", sender: self)
        }// end of if
        
        if singlesSelected == false {
            selectedUserID = feedJSON["result"]["couple"][indexPath.row][0]["ID"].string!
            performSegue(withIdentifier: "goToSelectedCouple", sender: self)
        }// end of if
    }// end of didSelectRowAt
    
    //MARK: - getFeedCall function
    func getFeed() {
        print(feedOffset)
        let callURL = baseURL + "/php/feed.new.php"
        let params : [String : Any] = ["token" : userToken!, "max-size" : numberUserLoaded, "single-offset" : feedOffset]
        
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                self.feedJSON = JSON(response.result.value!)
                if self.feedArray != nil {
                    self.feedArray.append(self.feedJSON)
                } else {
                    self.feedArray = [self.feedJSON]
                }
                //self.feedArray = [self.feedJSON]
                print(self.feedJSON)
                self.feedTableView.reloadData()
            } else {
                print("Failed to get Data : there was an error during the request")
                print("error: \(response.result.error!)")
            }//end of if/else
        }// end of request
    }// end of getFeed
    
    func getRestOfFeed() {
        print(feedOffset)
        let callURL = baseURL + "/php/feed.new.php"
        let params : [String : Any] = ["token" : userToken!, "max-size" : numberUserLoaded, "single-offset" : feedOffset]
        
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got data")
                self.feedJSON = JSON(response.result.value!)
                if self.feedArray != nil {
                    self.feedArray.append(self.feedJSON)
                } else {
                    self.feedArray = [self.feedJSON]
                }
                //self.feedArray = [self.feedJSON]
                print(self.feedJSON)
            } else {
                print("Failed to get Data : there was an error during the request")
                print("error: \(response.result.error!)")
            }//end of if/else
        }// end of request
        
    }
    
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
        if segue.identifier == "goToSelectedCouple" {
            let destinationVC = segue.destination as! CouplesUserProfileViewController
            destinationVC.userID = selectedUserID
        }//end of if
    }//end of prepare for segue
    
    func loadUserPicture(pictureURL : String) {
        print("loadUserPicture")
        var profilePicURL = pictureURL
        let dotsIndex = profilePicURL.startIndex..<profilePicURL.index(profilePicURL.startIndex, offsetBy: 2)
        profilePicURL.removeSubrange(dotsIndex)
        let callURL = baseURL + profilePicURL
        //var userImage : Image?
        
        Alamofire.request(callURL).responseImage {
            response in
            if response.result.isSuccess {
                print("alamofire request if")
                self.feedImages = response.result.value
            } else {
                print("there was an error getting the image")
                print("error: \(response.result.error!)")
            }//end of if/else
        }//end of request
        //return userImage ?? UIImage(named: "avatar_placeholder")!
    }//end of loadUserPicture
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// end of MainFeedViewController
