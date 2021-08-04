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
    @IBOutlet var rolePicker: UIPickerView!
    @IBOutlet var deleteButton: UIButton!
    
    weak var delegate: EditUserViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.getUser()
    }
    
    private func getUser() {
        self.nameTextField.alpha = 0.0
        self.deleteButton.alpha = 0
        self.rolePicker.alpha = 0
        self.showLoading()
        self.rolePicker.delegate = self
        self.rolePicker.dataSource = self
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
                return
            }
            self.showError(with: Strings.failure, message: error.displayString)
        }
        
        self.viewModel.didGetUser = {
            self.hideLoading()
            UIView.animate(withDuration: Constants.ANIMATION_TIME) {
                self.nameTextField.alpha = 1.0
                self.rolePicker.alpha = 1.0
                self.deleteButton.alpha = 1.0
            }
            self.nameTextField.text = self.viewModel.userName
            var row = 0
            if self.viewModel.role == Strings.regular {
                row = 0
            } else if self.viewModel.role == Strings.owner {
                row = 1
            } else if self.viewModel.role == Strings.admin {
                row = 2
            }
            self.rolePicker.selectRow(row, inComponent: 0, animated: false)
        }
    }
}

extension EditUserViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return Strings.regular
        } else if row == 1 {
            return Strings.owner
        }
        return Strings.admin
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    
}

extension EditUserViewController {
    @IBAction func didTapDoneButton(sender: UIButton) {
        let roles = [Strings.regular, Strings.owner, Strings.admin]
        self.viewModel.editUser(name: self.nameTextField.text!, role: roles[self.rolePicker.selectedRow(inComponent: 0)])
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
