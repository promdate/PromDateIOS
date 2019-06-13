//
//  CouplesSelectionLauncher.swift
//  PromDate app
//
//  Created by Olivier Caron on 2019-06-10.
//  Copyright © 2019 Olivier Caron. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CouplesSelectionLauncher: NSObject, UITableViewDelegate, UITableViewDataSource{
    //UICollectionViewDelegate, UICollectionViewDataSource
    var coupleInfo = MainFeedViewController().couplesArray
    //let coupleIndex = MainFeedViewController().currentIndexPath
    var coupleIndex = 0
    var userCellFilled = false
    let blackView = UIView()
    let placeholderImage = UIImage(named: "avatar_placeholder")
    
//    let collectionView : UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor.white
//        return cv
//    }()
    
    let tableView : UITableView = {
        let tv = UITableView(frame: .zero)
        tv.backgroundColor = UIColor.white
        tv.layer.cornerRadius = 10
        return tv
    }()
    
    func showPopUp() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            //window.addSubview(collectionView)
            window.addSubview(tableView)
            //let widthTV = window.frame.width - 75
            //let xPlacment = (window.frame.width - widthTV)/2
            let height  : CGFloat = 183
            let y = window.frame.height - height
            
            //tableView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            //collectionView.frame = CGRect(x: 0, y: window.frame.height/2 - 100, width: window.frame.width, height: 200)
            blackView.frame = window.frame
            blackView.alpha = 0
            //collectionView.alpha = 0
            //tableView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                //self.collectionView.alpha = 1
                //self.tableView.alpha = 1
                self.tableView.frame = CGRect(x: 0, y: y, width: self.tableView.frame.width, height: self.tableView.frame.height)
            }, completion: nil)
            
            
        }//end of if let
    }//end of couplesPopUp
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.tableView.frame = CGRect(x: 0, y: window.frame.height, width: self.tableView.frame.width, height: self.tableView.frame.height)
            }//end of if/let
        }//end of animation
    }//end of handleDismiss
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "singlesCell", for: indexPath)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singlesCell", for: indexPath) as! SinglesTableViewCell
        
        if userCellFilled == false {
            let profilePicURL = coupleInfo[coupleIndex].userPicURL
            let callURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com" + profilePicURL
            let urlRequest = URL(string: callURL)
            
            cell.nameLabel.text = coupleInfo[coupleIndex].userFirstName
            cell.bioLabel.text = coupleInfo[coupleIndex].userBio
            cell.gradeLabel.text = coupleInfo[coupleIndex].userGrade
            cell.avatarImageView.af_setImage(withURL: urlRequest!, placeholderImage: placeholderImage)
        } else {
            let profilePicURL = coupleInfo[coupleIndex].partnerPicURL
            let callURL = "http://ec2-35-183-247-114.ca-central-1.compute.amazonaws.com" + profilePicURL
            let urlRequest = URL(string: callURL)
            
            cell.nameLabel.text = coupleInfo[coupleIndex].partnerFirstName
            cell.bioLabel.text = coupleInfo[coupleIndex].partnerBio
            cell.gradeLabel.text = coupleInfo[coupleIndex].partnerGrade
            cell.avatarImageView.af_setImage(withURL: urlRequest!, placeholderImage: placeholderImage)
        }//end if if/else
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override init() {
        super.init()
        //start doing something here
        //collectionView.dataSource = self
        //collectionView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        //collectionView.register(UINib(nibName: "SinglesTableViewCell", bundle: nil), forCellWithReuseIdentifier: "singlesCell")
        tableView.register(UINib(nibName: "SinglesTableViewCell", bundle: nil), forCellReuseIdentifier: "singlesCell")
        
        userCellFilled = false
        coupleIndex = MainFeedViewController().currentIndexPath
        //coupleInfo = MainFeedViewController().couplesArray
    }//end of init()
    
    
    
}//end of CouplesSelectionLauncher
