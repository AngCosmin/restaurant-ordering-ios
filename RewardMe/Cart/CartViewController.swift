//
//  CartViewController.swift
//  RewardMe
//
//  Created by Cosmin on 24/03/2019.
//  Copyright © 2019 Cosmin. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftyJSON

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var tableId: Int = 0
    var products: [ProductModel] = [ProductModel]()
    var orderId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productsTable.delegate = self
        productsTable.dataSource = self
        productsTable.reloadData()
        
        calculateTotal()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartProductCell", for: indexPath) as! CartProductTableViewCell
        
        cell.name.text = products[indexPath.row].name
        cell.price.text = "\(products[indexPath.row].price)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let button = UITableViewRowAction(style: .normal, title: nil) { (action, index) in
            self.products.remove(at: index.section)
            self.productsTable.reloadData()
            self.calculateTotal()
        }
        
        button.title = "Remove"
        button.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.18, alpha:1.0)
        
        return [button]
    }

    
    func calculateTotal() {
        var total: Float = 0.0
        
        for product in products {
            total += product.price
        }
        
        totalLabel.text = "Total: \(total)"
    }
    
    @IBAction func onOrderPressed(_ sender: Any) {
        let email = Auth.auth().currentUser?.email
        var productsId = ""
        
        for product in products {
            productsId += "\(product.id),"
        }
        
        let parameters: Parameters = [
            "table_id": tableId,
            "email": email!,
            "products": productsId
        ]
        
        let url = "\(Constants.API_URL)/buy"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            let responseJson: JSON = JSON(response.result.value!)
            self.orderId = responseJson["orderId"].int!
            
            self.performSegue(withIdentifier: "goToFinishOrder", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFinishOrder" {
            if let vc = segue.destination as? FinishOrderViewController {
                vc.orderId = orderId
            }
        }
    }
}
