//
//  EditUserViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import UIKit

class EditUserViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    
    var viewModel: EditUserViewModel!
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var roleTextField: UITextField!
    @IBOutlet var deleteButton: UIButton!
    
    weak var delegate: EditUserViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.getUser()
    }
    
    private func getUser() {
        self.nameTextField.alpha = 0.0
        self.roleTextField.alpha = 0.0
        self.deleteButton.alpha = 0
        self.showLoading()
        self.viewModel.getUser()
    }
    
    private func bind() {
        self.viewModel.didDeleteUser = {
            self.dismiss(animated: true, completion: nil)
            self.hideLoading()
            self.delegate?.didCompleteActionIn(editUserViewController: self)
            self.showSuccess(with: Strings.success, message: Strings.userDeleted)
        }
        
        self.viewModel.didDeleteUserFail = { error in
            self.hideLoading()
            self.showError(with: Strings.failure, message: error.displayString)
        }
        
        self.viewModel.didEditUser = {
            self.dismiss(animated: true, completion: nil)
            self.hideLoading()
            self.delegate?.didCompleteActionIn(editUserViewController: self)
            self.showSuccess(with: Strings.success, message: Strings.userEdited)
        }
        
        self.viewModel.didEditUserFail = { error in
            self.hideLoading()
            if let validationError = error as? ValidationError {
                if validationError.type == .name {
                    self.nameTextField.shake()
                }
                if validationError.type == .role {
                    self.roleTextField.shake()
                }
                return
            }
            self.showError(with: Strings.failure, message: error.displayString)
        }
        
        self.viewModel.didGetUser = {
            self.hideLoading()
            UIView.animate(withDuration: Constants.ANIMATION_TIME) {
                self.nameTextField.alpha = 1.0
                self.roleTextField.alpha = 1.0
                self.deleteButton.alpha = 1.0
            }
            self.nameTextField.text = self.viewModel.userName
            self.roleTextField.text = self.viewModel.role
        }
    }
}

extension EditUserViewController {
    @IBAction func didTapDoneButton(sender: UIButton) {
        self.viewModel.editUser(name: self.nameTextField.text!, role: self.roleTextField.text!)
    }
    
    @IBAction func didTapDeleteButton(sender: UIButton) {
        self.viewModel.deleteUser()
    }
    
    @IBAction func didTapCancelButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

protocol EditUserViewControllerDelegate: AnyObject {
    func didCompleteActionIn(editUserViewController: EditUserViewController)
}
