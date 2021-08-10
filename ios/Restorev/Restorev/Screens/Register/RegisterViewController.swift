//
//  RegisterViewController.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

class RegisterViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    
    var viewModel: RegisterViewModel!
    var router: RegisterRouter!
    
    weak var delegate: RegisterViewControllerDelegate?
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
}

extension RegisterViewController {
    private func bind() {
        self.viewModel.didRegister = { [weak self] in
            guard let self = self else {
                return
            }
            self.router.dismiss()
            self.delegate?.didFinishRegisterIn(registerViewController: self)
            self.hideLoading()
        }
        
        self.viewModel.didRegisterFail = { [weak self] error in
            self?.hideLoading()
            if let error = error as? ValidationError {
                self?.performErrorAction(for: error)
            } else {
                self?.showError(with: Strings.failure, message: error.displayString)
            }
        }
    }
    
    private func performErrorAction(for validationError: ValidationError) {
        switch validationError.type {
        case .email: self.emailTextField.shake()
        case .name: self.nameTextField.shake()
        case .password: self.passwordTextField.shake()
        case .confirmPassword: self.confirmPasswordTextField.shake()
        case .passwordConfirmPassword:
            self.passwordTextField.shake()
            self.confirmPasswordTextField.shake()
        default: return
        }
    }
}

extension RegisterViewController {
    @IBAction func didTapRegisterButton(sender: AnyObject) {
        guard let name = self.nameTextField.text, let email = self.emailTextField.text, let password = self.passwordTextField.text, let confirmPassword = self.confirmPasswordTextField.text else {
            fatalError("These items cannot be null")
        }
        self.showLoading()
        self.viewModel.register(name: name, email: email, password: password, confirmPassword: confirmPassword)
    }
}

protocol RegisterViewControllerDelegate: AnyObject {
    func didFinishRegisterIn(registerViewController: RegisterViewController)
}
