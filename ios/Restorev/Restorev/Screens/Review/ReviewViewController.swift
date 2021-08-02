//
//  ReviewViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 01/08/21.
//

import UIKit
import Cosmos

class ReviewViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    var viewModel: ReviewViewModel!
    var delegate: ReviewViewControllerDelegate?
    
    @IBOutlet var reviewTextView: UITextView!
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.reviewTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bind() {
        self.viewModel.didPostReview = {
            self.hideLoading()
            self.showSuccess(with: Strings.success, message: Strings.reviewAdded)
            self.delegate?.reviewViewControllerDidDismiss(reviewViewController: self)
            self.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.didPostReviewFail = { error in
            self.hideLoading()
            if let validationError = error as? ValidationError {
                if validationError.type == .rating {
                    self.cosmosView.shake()
                } else if validationError.type == .review {
                    self.reviewTextView.shake()
                }
            } else {
                self.showError(with: Strings.failure, message: error.displayString)
            }
        }
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewViewController.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewViewController.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }

    @objc func keyboardWillShow(notification:NSNotification?) {
        let keyboardSize = (notification?.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as? NSValue)?.cgRectValue.size
           self.view.frame.origin.y = 0
           let keyboardYPosition = self.view.frame.size.height - keyboardSize!.height
        if keyboardYPosition < self.reviewTextView.frame.origin.y + self.reviewTextView.frame.size.height {
            UIView.animate(withDuration: Constants.ANIMATION_TIME) { () -> Void in
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize!.height + self.reviewTextView.frame.size.height
               }
           }
       }

    @objc func keyboardWillHide(notification:NSNotification?) {
        UIView.animate(withDuration: Constants.ANIMATION_TIME) { () -> Void in
               self.view.frame.origin.y = 0
           }
       }
}

extension ReviewViewController {
    @IBAction func didTapDoneButton(sender: UIButton) {
        self.showLoading()
        self.viewModel.postReview(review: self.reviewTextView.text, rating: Int(self.cosmosView.rating), visitedDate: self.datePicker.date)
    }
    
    @IBAction func didTapCancelButton(sender: UIButton) {
        self.dismiss(animated: true, completion: {
            self.delegate?.reviewViewControllerDidDismiss(reviewViewController: self)
        })
    }
}

protocol ReviewViewControllerDelegate {
    func reviewViewControllerDidDismiss(reviewViewController: ReviewViewController)
}
