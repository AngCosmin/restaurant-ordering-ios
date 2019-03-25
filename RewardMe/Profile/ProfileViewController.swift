//
//  ProfileViewController.swift
//  RewardMe
//
//  Created by Cosmin on 24/03/2019.
//  Copyright © 2019 Cosmin. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var history: [HistoryModel] = [HistoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        historyTable.delegate = self
        historyTable.dataSource = self
        
        let email = Auth.auth().currentUser?.email
        
        if email! == "ioanamoraru14@gmail.com" {
            profilePicture.image = UIImage(named: "ioana")
        }
        else {
            profilePicture.image = UIImage(named: "me")
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        self.historyTable.addGestureRecognizer(swipeRight)
        
        let name = Auth.auth().currentUser?.displayName
        userName.text = name!
        
        getHistory()
    }
    
    @objc func handleSwipeRight() {
        performSegue(withIdentifier: "goBackToMainScreen", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        
        cell.restaurantName.text = history[indexPath.row].restaurantName
        cell.price.text = "\(history[indexPath.row].price)"
        
        return cell
    }

    func getHistory() {
        let email = Auth.auth().currentUser?.email
        let parameters: Parameters = [
            "email": email!,
        ]
        
        let url = "\(Constants.API_URL)/history"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            let responseJson: JSON = JSON(response.result.value!)
            let result = responseJson["data"]
            
            for (_, value) in result {
                let item = HistoryModel()
                item.restaurantName = value["restaurant_name"].string!
                item.price = value["sum"].float!
                
                self.history.append(item)
            }
            
            self.historyTable.reloadData()
        }
    }
}
