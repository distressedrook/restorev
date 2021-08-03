//
//  AddRestaurantViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import UIKit

class AddRestaurantViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    var viewModel: AddRestaurantViewModel!
    @IBOutlet var titleLabel: UILabel!
    weak var delegate: AddRestaurantViewControllerDelegate?
    let roleManager = RoleManager()
    @IBOutlet var nameTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.titleLabel.text = self.roleManager.titleForAddRestaurantController()
        self.nameTextField.becomeFirstResponder()
        self.nameTextField.text = self.viewModel.name
    }
}

extension AddRestaurantViewController {
    @IBAction func didTapCancelButton(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(sender: UIButton) {
        self.showLoading()
        self.viewModel.postRestaurantName(name: self.nameTextField.text!)
    }
}

extension AddRestaurantViewController {
    private func bind() {
        self.viewModel.didPostRestaurant = {
            self.hideLoading()
            self.showSuccess(with: Strings.success, message: self.roleManager.messageForPostRestaurantName())
            self.delegate?.didPostNameIn(addRestaurantViewController: self)
            self.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.didPostRestaurantFail = { error in
            if let validationError = error as? ValidationError {
                if validationError.type == .name {
                    self.nameTextField.shake()
                }
                return
            }
            self.hideLoading()
            self.showError(with: Strings.failure, message: error.displayString)
        }
    }
}

protocol AddRestaurantViewControllerDelegate: AnyObject {
    func didPostNameIn(addRestaurantViewController: AddRestaurantViewController)
}
