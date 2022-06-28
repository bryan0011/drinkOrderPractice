//
//  DrinkMenuTableViewCell.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/20.
//

import UIKit

class DrinkMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var lPriceLabel: UILabel!
    @IBOutlet weak var mPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
