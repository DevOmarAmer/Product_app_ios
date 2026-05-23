//
//  ProductDetailsViewController.swift
//  Product
//
//  Created by Omar on 03/05/2026.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var descLabel: UILabel!
        @IBOutlet weak var categoryLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!
        @IBOutlet weak var ratingLabel: UILabel!

    @IBOutlet weak var productImageView: UIImageView!
    var product: Product?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.allowsSelection = false
        
        if let p = product {
                    titleLabel.text = p.title
                    descLabel.text = p.description
                    priceLabel.text = "Price: \(p.price)$"
            
            if let imageUrl = URL(string: p.thumbnail) {
                            productImageView?.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"))
                        }
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
