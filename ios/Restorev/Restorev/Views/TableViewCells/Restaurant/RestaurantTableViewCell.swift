//
//  RestaurantTableViewCell.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var averageRatingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static var nib: UINib {
        return UINib(nibName: "RestaurantTableViewCell", bundle: nil)
    }
    
    static var cellIdentifier: String {
        return "RestaurantTableViewCell"
    }
    
}
