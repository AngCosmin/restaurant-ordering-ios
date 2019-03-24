//
//  FinishOrderViewController.swift
//  RewardMe
//
//  Created by Cosmin on 24/03/2019.
//  Copyright © 2019 Cosmin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Cosmos

class FinishOrderViewController: UIViewController {
    var orderId: Int = 0
    var rating: Double = 3.0
    
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var ratingButton: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkStatus), userInfo: nil, repeats: true)
        
        ratingButton.didFinishTouchingCosmos = { rating in
            self.rating = rating
        }
    }
    
    @objc func checkStatus()
    {
        let parameters: Parameters = [
            "order_id": orderId,
        ]
        
        let url = "\(Constants.API_URL)/order/status"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            let responseJson: JSON = JSON(response.result.value!)
            let status = responseJson["status"].int!
            
            if status == 1 {
                self.orderStatus.text = "Pending"
            }
            else if status == 2 {
                self.orderStatus.text = "Recived"
                self.orderStatus.textColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            }
            else if status == 3 {
                self.orderStatus.text = "Paid"
                self.orderStatus.textColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            }
        }
    }
    
    @IBAction func onPayPressed(_ sender: Any) {
        let parameters: Parameters = [
            "order_id": orderId,
            "rating": rating,
        ]
        
        let url = "\(Constants.API_URL)/bill"
        
        payButton.isEnabled = false
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            SVProgressHUD.showSuccess(withStatus: "Complete!")
            SVProgressHUD.dismiss(withDelay: 2)
            
            self.performSegue(withIdentifier: "goToInitialState", sender: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
