//
//  MyCustomTableViewCell.swift
//  Product
//
//  Created by Omar on 21/05/2026.
//

import UIKit

class MyCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
        @IBOutlet weak var cellTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
