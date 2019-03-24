//
//  ProductsTableViewController.swift
//  RewardMe
//
//  Created by Cosmin on 23/03/2019.
//  Copyright © 2019 Cosmin. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import SwiftyJSON
import SVProgressHUD

class ProductsTableViewController: UITableViewController, ButtonPressedInCellDelegate {
    var tableId: Int = 1
    var products: [ProductModel] = [ProductModel]()
    var selectedProducts: [ProductModel] = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        tableView.rowHeight = self.view.frame.width
        
        let button = UIBarButtonItem(title: "Cart", style: .done, target: self, action: #selector(showCart))
        self.navigationItem.rightBarButtonItem = button
        
        print("Get \(tableId)")
        
        getProducts()
    }
    
    @objc func showCart() {
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
    func didTapAddButtonInCell(_ cell: ProductModel) {
        selectedProducts.append(cell)
        SVProgressHUD.showSuccess(withStatus: "Added")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell

        let imageUrl = products[indexPath.section].picture
        let url = URL(string: imageUrl)
        let data = try? Data(contentsOf: url!)
        
        cell.productId = products[indexPath.section].id
        cell.cardImageView.image = UIImage(data: data!)
        cell.nameLabel.text = products[indexPath.section].name
        cell.priceLabel.text = "\(products[indexPath.section].price)"
        cell.ratingLabel.text = products[indexPath.section].rating
        
        cell.delegate = self
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    func getProducts() {
        let parameters: Parameters = [
            "id_table": tableId,
        ]
        
        print(tableId)
        
        let url = "\(Constants.API_URL)/product"
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            let responseJson: JSON = JSON(response.result.value!)
            let result = responseJson["data"]
            
            for (_, value) in result {
                let product = ProductModel()
                product.id = value["id"].int!
                product.name = value["name"].string!
                product.category = value["category"].string!
                product.price = value["price"].float!
                product.picture = value["picture"].string!
                product.rating = value["rating"].string!
                
                self.products.append(product)
            }

            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCart" {
            if let vc = segue.destination as? CartViewController {
                vc.products = selectedProducts
                vc.tableId = tableId
            }
        }
    }
}
