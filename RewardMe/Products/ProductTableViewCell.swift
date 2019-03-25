//
//  ProductTableViewCell.swift
//  RewardMe
//
//  Created by Cosmin on 23/03/2019.
//  Copyright © 2019 Cosmin. All rights reserved.
//

import UIKit
protocol ButtonPressedInCellDelegate {
    func didTapAddButtonInCell(_ cell: ProductModel)
}

class ProductTableViewCell: UITableViewCell {

    var productId: Int = 0
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardContainerView: DropShadowView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    let cornerRadius : CGFloat = 25.0
    var delegate: ButtonPressedInCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        // Initialization code
        cardContainerView.layer.cornerRadius = cornerRadius
        cardContainerView.layer.shadowColor = UIColor.gray.cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cardContainerView.layer.shadowRadius = 15.0
        cardContainerView.layer.shadowOpacity = 0.9
        
        // setting shadow path in awakeFromNib doesn't work as the bounds / frames of the views haven't got initialized yet
        // at this point the cell layout position isn't known yet
        
        cardImageView.layer.cornerRadius = cornerRadius
        cardImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func addProductToCart(_ sender: Any) {
        let product = ProductModel()
        product.id = productId
        product.name = nameLabel.text!
        product.price = Float(priceLabel.text!)!
        
        delegate?.didTapAddButtonInCell(product)
    }
}
