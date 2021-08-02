//
//  PendingReviewsViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import UIKit

class PendingRestaurantsViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    
    var viewModel: PendingRestaurantsViewModel!
    var router: PendingRestaurantsRouter!
    let roleManager = RoleManager()
    
    @IBOutlet var reviewsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()
        self.setupTableView()
        self.bind()
        self.reviewsTableView.alpha = 0.0
        self.viewModel.getPendingRestaurants()
    }
    
    private func setupTableView() {
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        self.reviewsTableView.register(ReviewTableViewCell.nib, forCellReuseIdentifier: ReviewTableViewCell.cellIdentifier)
    }
    
    private func bind() {
        self.viewModel.didFindPendingResaturants = {
            self.reviewsTableView.reloadData()
            self.hideLoading()
            UIView.animate(withDuration: Constants.ANIMATION_TIME) {
                self.reviewsTableView.alpha = 1.0
            }
        }
        
        self.viewModel.didFindPendingRestaurantsFail = { error in
            self.hideLoading()
            self.showError(with: Strings.failure, message: error.displayString)
        }
    }
}

extension PendingRestaurantsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfRestauranats
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfPendingReviews(at: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerLabelWith(restaurantName: self.viewModel.restaurantName(at: section))
    }
    
    private func headerLabelWith(restaurantName: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.openSansBold(with: 15)
        label.backgroundColor = UIColor.backgroundWhite
        label.text = "     " + restaurantName
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.cellIdentifier) as! ReviewTableViewCell
        self.configure(cell: cell, for: indexPath)
        cell.delegate = self
        return cell
    }
    
    func configure(cell: ReviewTableViewCell, for indexPath: IndexPath) {
        NSLayoutConstraint.activate([cell.commentHeightConstraint])
        cell.commentHeightConstraint.constant = 0
        cell.commentLabel.text = nil
        cell.ownerTitleLabel.text = nil
        if let image = self.roleManager.rightButtonImageForReviewCell() {
            cell.commentButton.isHidden = false
            cell.commentButton.setImage(image, for: .normal)
        }
        cell.selectionStyle = .none
        cell.ratingLabel.text = String(self.viewModel.reviewAt(restaurantIndex: indexPath.section, reviewIndex: indexPath.row).rating)
        cell.reviewerLabel.text = self.viewModel.reviewAt(restaurantIndex: indexPath.section, reviewIndex: indexPath.row).reviewer!.name
        cell.reviewLabel.text = self.viewModel.reviewAt(restaurantIndex: indexPath.section, reviewIndex: indexPath.row).review
    }
}

extension PendingRestaurantsViewController: ReviewTableViewCellDelegate {
    func didTapCommentButtonIn(reviewTableViewCell: ReviewTableViewCell) {
        let indexPath = reviewsTableView.indexPath(for: reviewTableViewCell)!
        self.router.moveToComment(review: self.viewModel.reviewAt(restaurantIndex: indexPath.section, reviewIndex: indexPath.row), delegate: self)
    }
}

extension PendingRestaurantsViewController: CommentViewControllerDelegate {
    func didPostCommentIn(commentViewController: CommentViewController) {
        self.reviewsTableView.alpha = 0.0
        self.viewModel.getPendingRestaurants()
        self.showLoading()
    }
}
