//
//  NotificationsViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-05-16.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //variables
    @IBOutlet weak var notificationTableView: UITableView!
    
    let baseURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com"
    var userToken = UserData().defaults.string(forKey: "userToken")
    var notificationJSON : JSON!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //setting self as delegate and dataSource for tableView
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
        //register cell
        notificationTableView.register(UINib(nibName: "SinglesTableViewCell", bundle: nil), forCellReuseIdentifier: "singlesCell")
        
        //we call congifureTableView to set the height of the cells
        configureTableView()
        
        //we call getNotificationData
        getNotificationData()
    }//end of viewDidLoad
    
    //MARK: - Declare cellForRowAt method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //we declare the cell which will be used for the notification information
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlesCell", for: indexPath) as! SinglesTableViewCell
        
        
        return cell
    }//end of cellForRowAt
    
    
    //MARK: - Declare numberOfRowsInSection method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }//end of numberOfRowsInSection
    
    func getNotificationData(){
        let callURL = baseURL + "/php/notifications.php"
        let params : [String : Any] = ["token" : userToken!]
        
        Alamofire.request(callURL, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                print("sucess got notification Data!")
                print(response.result.value!)
                self.notificationJSON = JSON(response.result.value!)
            } else {
                print("there was an error getting the notification data")
                print("this is the error code: \(response.result.error!)")
            }//end of if/else
        }//end of request
    }//end of getNotificationData
    
    func configureTableView() {
        notificationTableView.rowHeight = UITableView.automaticDimension
        notificationTableView.estimatedRowHeight = 60.0
    }//end of configureTableView

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of NotificationsViewController
