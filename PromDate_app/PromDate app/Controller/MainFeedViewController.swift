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
    var feedImages : Image!
    var singlesArray = [UserModel]()
    var couplesArray = [CouplesUserModel]()
    var immageArray = [ProfilePictureModel]()
    var selectedUserID = ""
    let numberUserLoaded = 15
    var feedArraysFilled = false
    var initialLoad = false
    var feedComplete = false
    var userToken = UserData().defaults.string(forKey: "userToken")
    var feedOffset = 0
    var couplesOffset = 0
    var singlesImmageArray = [Image]()
    let placeholderImage = UIImage(named: "avatar_placeholder")

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
        
        //giving singlesArrayFilled a default value of false and initial load as false
        feedArraysFilled = false
        initialLoad = false
        feedComplete = false
        
        // call some kind of function that loads singles data --> dataLoaded() or loadData()
        configureTableView()
        
        //we make sure feedoffset is = to 0
        feedOffset = 0
        couplesOffset = 0
        
        //get user data
        getFeed()
    }//end of viewDidLoad
    
    
    @IBAction func feedIndexChanged(_ sender: UISegmentedControl) {
        switch feedSegmentedControl.selectedSegmentIndex {
        case 0:
            print("Couples Selected")
            // set singles as selected
            singlesSelected = false
            //feedComplete = false
            feedTableView.reloadData()
        case 1:
            print("Singles Selected")
            // set couples as selected
            singlesSelected = true
            //feedComplete = false
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
        
    }//end of prefetchRowsAt
    
    // MARK: - Declare cellForRowAT
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if that changes the custom cell depending on what segment is choosen ( Singles or couples)
        if singlesSelected == true {
            //if that checks if the index path if equal to the #of users in the singlesArray and if so loads another 15 users
            if indexPath.row == singlesArray.count - 1 && singlesArray.count >= 15 {
                if feedComplete == false {
                    print("loading next page")
                    feedOffset += 15
                    print("Feed offset: \(feedOffset)")
                    getRemainingFeed()
                }//end of if
            }//end of if
            
            // initialization of cell which is the var with the custom cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "singlesCell", for: indexPath) as! SinglesTableViewCell
            
            
//            if indexPath.row <= singlesImmageArray.count {
//                cell.avatarImageView.image = singlesImmageArray[indexPath.row]
//            } else {
//                cell.avatarImageView.image = UIImage(named: "avatar_placeholder")
//            }//end of if/else
            
            let profilePicURL = singlesArray[indexPath.row].userPicURL
            let callURL = baseURL + profilePicURL
            let urlRequest = URL(string: callURL)
            cell.avatarImageView.af_setImage(withURL: urlRequest!, placeholderImage: placeholderImage)
            
            cell.nameLabel.text = singlesArray[indexPath.row].userFirstName
            cell.gradeLabel.text = "Grade: \(singlesArray[indexPath.row].userGrade)"
            cell.bioLabel.text = singlesArray[indexPath.row].userBio
            
            return cell
        } else {
            
            if indexPath.row == couplesArray.count - 1 && couplesArray.count >= 15 {
                if feedComplete == false {
                    print("loading next page")
                    couplesOffset += 15
                    print("feed offset: \(couplesOffset)")
                    getRemainingFeed()
                }//end of if
            }//end of if
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "couplesCell", for: indexPath) as! CouplesTableViewCell
            
            let usrProfilePicURL = couplesArray[indexPath.row].userPicURL
            let prtnProfilePicURL = couplesArray[indexPath.row].partnerPicURL
            let usrCallURL = baseURL + usrProfilePicURL
            let prtnCallURL = baseURL + prtnProfilePicURL
            let usrUrlRequest = URL(string: usrCallURL)
            let prtnUrlRequest = URL(string: prtnCallURL)
            cell.firstAvatarImageView.af_setImage(withURL: usrUrlRequest!, placeholderImage: placeholderImage)
            cell.seccondAvatarImageView.af_setImage(withURL: prtnUrlRequest!, placeholderImage: placeholderImage)
            
            
            cell.couplesNamesLabel.text = "\(couplesArray[indexPath.row].userFirstName) & \(couplesArray[indexPath.row].partnerFirstName)"
            return cell
        }// end of if/else
    }// end of cellForRowAt
    
    //MARK: - Declare numbersOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 11
        print("entered numbersOfRowsInSection")
        if feedArraysFilled == true {
            if singlesSelected == true{
                return singlesArray.count
            } else {
                return couplesArray.count
            }//end of if/else
        } else {
            return 0
        }//end of if/else
    }// end of numbersOfRowsInSection
    
    //MARK: - didSelectRowAt function
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if singlesSelected == true {
            selectedUserID = singlesArray[indexPath.row].id
            performSegue(withIdentifier: "goToSelectedUser", sender: self)
        }// end of if
        
        if singlesSelected == false {
            selectedUserID = couplesArray[indexPath.row].userID
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
                let responseJSON : JSON = JSON(response.result.value!)
                print(responseJSON)
                self.initialLoad = true
                self.processFeedData(feedJSON: responseJSON)
            } else {
                print("Failed to get Data : there was an error during the request")
                print("error: \(response.result.error!)")
            }//end of if/else
        }// end of request
    }// end of getFeed
    
    func processFeedData(feedJSON : JSON) {
        print("processFeedData entered")
        print("Singles Selected: \(singlesSelected)")
        //big if that checks if this is the initial load of data or if singles selected is true
        
        if singlesSelected == true || initialLoad == true {
            if feedJSON["result"]["single"].count >= 1 {
                for index in 0...feedJSON["result"]["single"].count - 1 {
                    singlesArray.append(UserModel(gender: feedJSON["result"]["single"][index]["Gender"].string ?? "", grade: feedJSON["result"]["single"][index]["Grade"].string ?? "", lastName: feedJSON["result"]["single"][index]["LastName"].string!, schoolID: feedJSON["result"]["single"][index]["SchoolID"].string!, bio: feedJSON["result"]["single"][index]["Biography"].string ?? "", userID: feedJSON["result"]["single"][index]["ID"].string!, firstName: feedJSON["result"]["single"][index]["FirstName"].string!, profilePicURL: feedJSON["result"]["single"][index]["ProfilePicture"].string!))
                }//end for loop
                loadUserPicture()
            } else {
                feedComplete = true
            }//end of if/else
        }//end of if
        
        if singlesSelected == false || initialLoad == true {
            if feedJSON["result"]["couple"].count >= 1 {
                print("just before for loop for couples")
                for index in 0...feedJSON["result"]["couple"].count - 1 {
                    couplesArray.append(CouplesUserModel(usrSchoolID: feedJSON["result"]["couple"][index][0]["SchoolID"].string!, usrFirstName: feedJSON["result"]["couple"][index][0]["FirstName"].string!, usrLastName: feedJSON["result"]["couple"][index][0]["LastName"].string!, usrBio: feedJSON["result"]["couple"][index][0]["Biography"].string!, usrGender: feedJSON["result"]["couple"][index][0]["Gender"].string ?? "", usrID: feedJSON["result"]["couple"][index][0]["ID"].string!, usrGrade: feedJSON["result"]["couple"][index][0]["Gender"].string ?? "", prtnSchoolID: feedJSON["result"]["couple"][index][1]["SchoolID"].string!, prtnFirstName: feedJSON["result"]["couple"][index][1]["FirstName"].string!, prtnLastName: feedJSON["result"]["couple"][index][1]["LastName"].string!, prtnBio: feedJSON["result"]["couple"][index][1]["Biography"].string!, prtnGender: feedJSON["result"]["couple"][index][1]["Gender"].string ?? "", prtnID: feedJSON["result"]["couple"][index][1]["ID"].string!, prtnGrade: feedJSON["result"]["couple"][index][1]["Grade"].string ?? "", usrPic: feedJSON["result"]["couple"][index][0]["ProfilePicture"].string!, prtnPic: feedJSON["result"]["couple"][index][1]["ProfilePicture"].string!))
                }//end of for loop
            } else {
                feedComplete = true
            }//end of if/else
        }//end of if
        
        //self.feedOffset += self.numberUserLoaded
        initialLoad = false
        print("end of forloop")
        feedArraysFilled = true
        //loadUserPicture()
        self.feedTableView.reloadData()
    }//end of processFeedData
    
    
    func getRemainingFeed() {
        print("getRemainingFeed")
        print(feedOffset)
        let callURL = baseURL + "/php/feed.new.php"
        //let params : [String : Any] = ["token" : userToken!, "max-size" : numberUserLoaded, "single-offset" : feedOffset]
        
        if singlesSelected == true {
            let params : [String : Any] = ["token" : userToken!, "max-size" : numberUserLoaded, "single-offset" : feedOffset]
            
            Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("sucess got data")
                    let responseJSON : JSON = JSON(response.result.value!)
                    print(responseJSON)
                    self.processFeedData(feedJSON: responseJSON)
                } else {
                    print("Failed to get Data : there was an error during the request")
                    print("error: \(response.result.error!)")
                }//end of if/else
            }// end of request
        }//end of if
        
        if singlesSelected == false {
            print("Feedoffset: \(feedOffset)")
            let params : [String : Any] = ["token" : userToken!, "max-size" : numberUserLoaded, "couple-offset" : couplesOffset]
            
            Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
                response in
                if response.result.isSuccess {
                    print("sucess got data")
                    let responseJSON = JSON(response.result.value!)
                    print(responseJSON)
                    self.processFeedData(feedJSON: responseJSON)
                } else {
                    print("there was an error getting the data \n please try later")
                    print("here is the error code: \(response.result.error!)")
                }//end of if/else
            }//end of request
            
        }//end of if
    }//end of getRemainingFeed
    
    
    //MARK: - Declare configureTableView
    //configureTableView is a func which allows the tableViewCells to have the good rowHeight so that the custom cells will fit properly
    func configureTableView() {
        //feedTableView.rowHeight = UITableView.automaticDimension
        feedTableView.rowHeight = 70.0
        feedTableView.estimatedRowHeight = 70.0
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
    
    func loadUserPicture() {
        var numberOfTimes = 0
        for index in 0...singlesArray.count - 1 {
            numberOfTimes += 1
            print("load user Picture: \(numberOfTimes)")
            print("index: \(index)")
            let profilePicURL = singlesArray[index].userPicURL
            let callURL = baseURL + profilePicURL
            
            Alamofire.request(callURL).responseImage {
                response in
                if response.result.isSuccess {
                    self.singlesImmageArray.append(response.result.value!)
                    print("SinglesArray.count : \(self.singlesImmageArray.count) singlesArray: \(self.singlesArray.count)")
                    if self.singlesArray.count == self.singlesImmageArray.count {
                        self.feedTableView.reloadData()
                    }//end of if
                } else {
                    print("there was an error getting the data")
                    print("here is the error code: \(response.result.error!)")
                }//end of if/else
            }//end of request
        }//end of for loop
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
