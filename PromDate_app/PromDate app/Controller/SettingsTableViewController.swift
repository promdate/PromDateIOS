//
//  SettingsTableViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-04-18.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsTableViewController: UITableViewController {
    
    //variables
    var userToken = UserData().defaults.string(forKey: "userToken")
    let baseURL : String = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var settingsArray = ["Profile","Change Password", "Apparel Registery", "Delete Account"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = settingsArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    //MARK: - TableViewDelegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            performSegue(withIdentifier: "goToUserProfile", sender: self)
        case 1 :
            performSegue(withIdentifier: "goToChangePassword", sender: self)
        case 2 :
            performSegue(withIdentifier: "goToApparelRegistery", sender: self)
        case 3 :
            deleteAccount()
        default :
            break
        }// end of switch
    }// end of didSelectRowAt
    
    
    //MARK: - logoutPressed
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let finalURL = baseURL + "/php/logout.php"
        let params : [String : String] = ["token" : userToken!]
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout ?", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .default, handler: { (UIAlertAction) in
            Alamofire.request(finalURL, method: .post, parameters: params).responseJSON {
                response in
                if response.result.isSuccess{
                    print("succes got data")
                    //let logoutJSON : JSON = JSON(response.result.value!)
                    let logoutSucess : JSON = JSON(response.result.value!)["status"]
                    //let logoutSucess = logoutJSON["status"]
                    if logoutSucess == 200 {
                        print("logout sucessfull")
                        // we delete the user's login information from the userDefaults
                        UserData().defaults.set("", forKey: "userToken")
                        UserData().defaults.set("", forKey: "keepEmail")
                        UserData().defaults.set("", forKey: "keepPassword")
                        UserData().defaults.set(false, forKey: "isLoggedIn")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("logout unsucessfull please try again")
                    }// end of if/else
                } else {
                    print ("There was an error communicating with the server, please try again")
                    print("this is the error code: \(response.result.error!)")
                }// end of if/else
            }// end of request
        })// end of logoutAction
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(logoutAction)
        self.present(alert, animated: true, completion: nil)
    }// end of logoutPressed
    
    
    //MARK: - Delete account methods
    
    // TODO: - deleteAccount func
    func deleteAccount() {
        
    }// end of deleteAccount
    
    //TODO: - delete account confirm prompt and call
    

    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// end of settingsViewController
