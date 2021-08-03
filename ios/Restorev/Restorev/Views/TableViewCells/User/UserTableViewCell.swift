//
//  UserTableViewCell.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    weak var delegate: UserTableViewCellDelegate?
    
    static var nib: UINib {
        return UINib(nibName: "UserTableViewCell", bundle: nil)
    }
    
    static var cellIdentifier: String {
        return "UserTableViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTapEditButton(sender: UIButton) {
        self.delegate?.didTapEditButtonIn(userTableViewCell: self)
    }
}

protocol UserTableViewCellDelegate: AnyObject {
    func didTapEditButtonIn(userTableViewCell: UserTableViewCell)
}
