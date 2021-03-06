//
//  CommentViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import UIKit

class CommentViewController: UIViewController, MessageDisplayable, LoadingIndicatable {
    var viewModel: CommentViewModel!
    
    @IBOutlet var reviewContainerView: UIView!
    @IBOutlet var reviewerNameLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var visitedDateLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var deleteButton: UIButton!
    let roleManager = RoleManager()
    
    weak var delegate: CommentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.setupLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForNotifications()
        self.deleteButton.isHidden = !self.roleManager.shouldShowDeleteButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewViewController.keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ReviewViewController.keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }

    @objc func keyboardWillShow(notification:NSNotification?) {
        let keyboardSize = (notification?.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as? NSValue)?.cgRectValue.size
           self.view.frame.origin.y = 0
           let keyboardYPosition = self.view.frame.size.height - keyboardSize!.height
        if keyboardYPosition < self.commentTextView.frame.origin.y + self.commentTextView.frame.size.height {
            UIView.animate(withDuration: Constants.ANIMATION_TIME) { () -> Void in
                self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize!.height + self.commentTextView.frame.size.height
               }
           }
       }

    @objc func keyboardWillHide(notification:NSNotification?) {
        UIView.animate(withDuration: Constants.ANIMATION_TIME) { () -> Void in
               self.view.frame.origin.y = 0
        }
    }
}

extension CommentViewController {
    private func bind() {
        self.viewModel.didPostComment = {
            self.hideLoading()
            self.showSuccess(with: Strings.success, message: self.roleManager.addCommentSuccessMessage())
            self.dismiss(animated: true, completion: nil)
            self.delegate?.didPostCommentIn(commentViewController: self)
        }
        
        self.viewModel.didPostCommentFail = { error in
            self.hideLoading()
            if error is ValidationError {
                self.commentTextView.shake()
                return
            }
            self.showError(with: Strings.failure, message: error.displayString)
        }
    }
    
    private func setupLabels() {
        self.reviewLabel.text = self.viewModel.review
        self.ratingLabel.text = "\(self.viewModel.reviewRating)"
        self.reviewerNameLabel.text = self.viewModel.reviewerName
        self.visitedDateLabel.text = Strings.visitedOn + Date(timeIntervalSince1970: TimeInterval(self.viewModel.reviewerVisitedDate)).toString().components(separatedBy: ",")[0]
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.commentTextView.text = self.viewModel.comment
    }
}

extension CommentViewController {
    @IBAction func didTapCancelButton(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(sender: AnyObject) {
        self.showLoading()
        self.viewModel.postComment(comment: self.commentTextView.text!)
    }
    
    @IBAction func didTapDeleteButton(sender: AnyObject) {
        self.viewModel.deleteComment()
    }
}

protocol CommentViewControllerDelegate: AnyObject {
    func didPostCommentIn(commentViewController: CommentViewController)
}
