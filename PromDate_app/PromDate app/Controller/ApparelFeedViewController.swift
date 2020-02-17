//
//  ApparelFeedViewController.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-06-07.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit

class ApparelFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //variables
    @IBOutlet weak var apparelFeedTableView: UITableView!
    
    let apparelBrandArray = ["Nice Dress", "Pretty dress", "Beautiful dress", "Cute dress", "Hot dress", "Sexy dress", "Yet another dress", "Too many dresses!", "Something possibly nice", "Finally the last dress"]
    let apparelModelNumberArray = ["#001", "#002", "#003", "#004", "#005", "#006", "Bond, James Bond", "#008", "#009", "#010"]
    let dress_Placeholder = UIImage(named: "dress_placeholder")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //we set ourselves as delegates
        apparelFeedTableView.delegate = self
        apparelFeedTableView.dataSource = self
        
        //we register our costum cells
        apparelFeedTableView.register(UINib(nibName: "ApparelTableViewCell", bundle: nil), forCellReuseIdentifier: "apparelCell")
        
        //we configure the tableView with the right row heights
        configureTableView()

        // Do any additional setup after loading the view.
    }//end of viewDidLoad
    
    //MARK: - TableView delegate and DataSource functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }//end of numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apparelCell", for: indexPath) as! ApparelTableViewCell
        cell.brandLabel.text = apparelBrandArray[indexPath.row]
        cell.modelNumberLabel.text = "Model number: \(apparelModelNumberArray[indexPath.row])"
        cell.apparelImageView.image = dress_Placeholder
        
        return cell
    }//end of cellForRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToApparelProfile", sender: self)
    }//end of didSelectRowAt
    
    func configureTableView() {
        apparelFeedTableView.rowHeight = 100
        apparelFeedTableView.estimatedRowHeight = 100
    }//end of configureTableView

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//end of ApparelFeedViewController
