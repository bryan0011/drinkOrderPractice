//
//  OrderListTableViewCell.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/26.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
