//
//  RestaurantDetailViewController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit
import Cosmos

class RestaurantDetailViewController: UIViewController, MessageDisplayable, LoadingIndicatable {
    var viewModel: RestaurantDetailViewModel!
    var router: RestaurantDetailRouter!
    let roleManager = RoleManager()
    
    @IBOutlet var restaurantNameLabel: UILabel!
    @IBOutlet var averageRatingLabel: UILabel!
    @IBOutlet var reviewsTableView: UITableView!
    @IBOutlet var restaurantDetailContainerView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.roleManager.rightBarButtonItemFor(restaurantDetailViewController: self)
        self.bind()
        self.hideViews()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
        self.viewModel.getDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func populateLabels() {
        self.restaurantNameLabel.text = self.viewModel.restaurantName
        self.averageRatingLabel.text = String(format: "%.2f", self.viewModel.averageRating) + " " + Strings.averageRating
    }
    
    private func bind() {
        self.viewModel.didGetRestaurantDetail = {
            self.populateLabels()
            self.reviewsTableView.reloadData()
            self.showViewAnimated()
            self.hideLoading()
        }
        self.viewModel.didGetRestaurantDetailFail = { error in
            self.hideLoading()
            self.showError(with: Strings.failure, message: error.displayString)
        }
    }
    
    private func hideViews() {
        self.reviewsTableView.alpha = 0.0
        self.restaurantDetailContainerView.alpha = 0.0
    }
    
    private func showViewAnimated() {
        UIView.animate(withDuration: Constants.ANIMATION_TIME) {
            self.reviewsTableView.alpha = 1.0
            self.restaurantDetailContainerView.alpha = 1.0
        }
    }
    
    private func setupTableView() {
        self.reviewsTableView.delegate = self
        self.reviewsTableView.dataSource = self
        self.reviewsTableView.register(ReviewTableViewCell.nib, forCellReuseIdentifier: ReviewTableViewCell.cellIdentifier)
    }
    
    @objc func didTapReviewButton(sender: UIBarButtonItem) {
        let restaurantName = self.viewModel.restaurantName
        let restaurantId = self.viewModel.restaurantId
        if let title = sender.title, title == Strings.review {
            self.router.moveToReview(restaurantName: restaurantName, restaurantId: restaurantId, delegate: self)
        } else if let title = sender.title, title == Strings.edit {
            self.router.moveToEditWith(restaurantId: restaurantId, restaurantName: restaurantName, delegate: self)
        }
    }
}

extension RestaurantDetailViewController: ReviewViewControllerDelegate {
    func reviewViewControllerDidDismiss(reviewViewController: ReviewViewController) {
        self.hideViews()
        self.showLoading()
        self.viewModel.getDetail()
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

extension RestaurantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.numberOfReviews == 0 {
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        return self.viewModel.numberOfReviews
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.cellIdentifier) as! ReviewTableViewCell
        if indexPath.section == 0 {
            configureTopRated(cell: cell)
        } else if indexPath.section == 1 {
            configureMostCritical(cell: cell)
        } else {
            configure(cell: cell, for: indexPath)
        }
        cell.delegate = self
        return cell
    }
    
    func configure(cell: ReviewTableViewCell, for indexPath: IndexPath) {
        if let comment = self.viewModel.commentAt(index: indexPath.row) {
            NSLayoutConstraint.deactivate([cell.commentHeightConstraint])
            cell.commentLabel.text = comment
            cell.ownerTitleLabel.text = self.roleManager.commentTitleLabelForRestaurant(name: self.viewModel.restaurantName)
            cell.commentButton?.isHidden = true
        } else {
            NSLayoutConstraint.activate([cell.commentHeightConstraint])
            cell.commentHeightConstraint.constant = 0
            cell.commentLabel.text = nil
            cell.ownerTitleLabel.text = nil
            cell.commentButton?.isHidden = false
        }
        cell.selectionStyle = .none
        cell.ratingLabel.text = String(self.viewModel.ratingAt(index: indexPath.row))
        cell.reviewerLabel.text = self.viewModel.reviewerNameAt(index: indexPath.row)
        cell.reviewLabel.text = self.viewModel.reviewAt(index: indexPath.row)
    }
    
    func configureTopRated(cell: ReviewTableViewCell) {
        if let comment = self.viewModel.topRatedOwnerComment {
            NSLayoutConstraint.deactivate([cell.commentHeightConstraint])
            cell.commentLabel.text = comment
            cell.ownerTitleLabel.text = self.roleManager.commentTitleLabelForRestaurant(name: self.viewModel.restaurantName)
            cell.commentButton?.isHidden = true
        } else {
            NSLayoutConstraint.activate([cell.commentHeightConstraint])
            cell.commentHeightConstraint.constant = 0
            cell.commentLabel.text = nil
            cell.ownerTitleLabel.text = nil
            cell.commentButton?.isHidden = false
        }
        cell.selectionStyle = .none
        cell.ratingLabel.text = String(self.viewModel.topRatedRating)
        cell.reviewerLabel.text = self.viewModel.topReviewerName
        cell.reviewLabel.text = self.viewModel.topRatedReviewString
    }
    
    func configureMostCritical(cell: ReviewTableViewCell) {
        if let comment = self.viewModel.mostCriticalOwnerComment {
            NSLayoutConstraint.deactivate([cell.commentHeightConstraint])
            cell.commentLabel.text = comment
            cell.ownerTitleLabel.text = self.roleManager.commentTitleLabelForRestaurant(name: self.viewModel.restaurantName)
            cell.commentButton?.isHidden = true
        } else {
            cell.commentLabel.text = nil
            cell.ownerTitleLabel.text = nil
            cell.commentHeightConstraint.constant = 0
            NSLayoutConstraint.activate([cell.commentHeightConstraint])
            cell.commentButton?.isHidden = false
        }
        cell.selectionStyle = .none
        cell.ratingLabel.text = String(self.viewModel.mostCriticalRating)
        cell.reviewerLabel.text = self.viewModel.mostCriticalReviewerName
        cell.reviewLabel.text = self.viewModel.mostCriticalReviewString
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return self.topRatedLabel
        } else if section == 1 {
            return self.mostCriticalLabel
        }
        return self.allReviewsLabel
    }
    
    private var mostCriticalLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.openSansBold(with: 15)
        label.backgroundColor = UIColor.backgroundWhite
        label.text = "     " + Strings.mostCriticalReview
        return label
    }
    
    private var topRatedLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.openSansBold(with: 15)
        label.backgroundColor = UIColor.backgroundWhite
        label.text = "     " + Strings.topRatedReview
        return label
    }
    
    private var allReviewsLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.openSansBold(with: 15)
        label.backgroundColor = UIColor.backgroundWhite
        label.text = "     " + Strings.allReviews
        return label
    }
}

extension RestaurantDetailViewController: CommentViewControllerDelegate {
    func didPostCommentIn(commentViewController: CommentViewController) {
        self.showLoading()
        self.viewModel.getDetail()
    }
}

extension RestaurantDetailViewController: AddRestaurantViewControllerDelegate {
    func didDeleteRestaurantIn(addRestaurantViewController: AddRestaurantViewController) {
        self.router.pop()
    }
    
    func didPostNameIn(addRestaurantViewController: AddRestaurantViewController) {
        self.showLoading()
        self.viewModel.getDetail()
    }
}

extension RestaurantDetailViewController: ReviewTableViewCellDelegate {
    func didTapCommentButtonIn(reviewTableViewCell: ReviewTableViewCell) {
        if let indexPath = self.reviewsTableView.indexPath(for: reviewTableViewCell) {
            if indexPath.section == 0 {
                self.router.moveToComment(review: self.viewModel.topRatedReview, delegate: self)
            } else if indexPath.section == 1 {
                self.router.moveToComment(review: self.viewModel.mostCriticalReview, delegate: self)
            } else if indexPath.section == 2 {
                self.router.moveToComment(review: self.viewModel.mReview(at: indexPath.row), delegate: self)
            }
        }
    }
    
    func didTapEditCommentButtonIn(reviewTableViewCell: ReviewTableViewCell) {
        
    }
    
    func didTapEditReviewButtonIn(reviewTableViewCell: ReviewTableViewCell) {
        
    }
}
