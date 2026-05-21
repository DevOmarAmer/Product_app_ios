//
//  ProductTableViewCell.swift
//  Product
//
//  Created by Omar on 04/05/2026.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

        @IBOutlet weak var productImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
      

    override func layoutSubviews() {
            super.layoutSubviews()

            productImageView.layer.cornerRadius = productImageView.frame.size.width / 2
        }

}
