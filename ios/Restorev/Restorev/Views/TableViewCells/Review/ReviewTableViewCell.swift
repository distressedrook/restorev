//
//  ReviewTableViewCell.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var reviewerLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var visitedOnLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var ownerTitleLabel: UILabel!
    
    @IBOutlet var commentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var commentButton: UIButton?
    @IBOutlet var reviewEditButton: UIButton?
    @IBOutlet var commentEditButton: UIButton?
    
    
    
    weak var delegate: ReviewTableViewCellDelegate?
    
    static var cellIdentifier: String {
        return "ReviewTableViewCell"
    }
    
    static var nib: UINib {
        let roleManager = RoleManager()
        return UINib(nibName: roleManager.nibNameForReviewTableViewCell(), bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ReviewTableViewCell {
    @IBAction func didTapCommentButton(sender: UIButton) {
        self.delegate?.didTapCommentButtonIn(reviewTableViewCell: self)
    }
    
    @IBAction func didTapEditReviewButton(sender: UIButton) {
        self.delegate?.didTapEditReviewButtonIn(reviewTableViewCell: self)
    }
    
    @IBAction func didTapEditCommentButton(sender: UIButton) {
        self.delegate?.didTapEditCommentButtonIn(reviewTableViewCell: self)
    }
}

protocol ReviewTableViewCellDelegate: AnyObject {
    func didTapCommentButtonIn(reviewTableViewCell: ReviewTableViewCell)
    func didTapEditReviewButtonIn(reviewTableViewCell: ReviewTableViewCell)
    func didTapEditCommentButtonIn(reviewTableViewCell: ReviewTableViewCell)
}
