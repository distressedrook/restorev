//
//  RegisterViewController.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

class LoginViewController: UIViewController, MessageDisplayable, LoadingIndicatable {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    var viewModel: LoginViewModel!
    var router: LoginRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
}

extension LoginViewController {
    private func bind() {
        self.viewModel.didRegisterFail = { error in
            self.hideLoading()
            if let validationError = error as? ValidationError {
                if validationError.type == .email {
                    self.emailTextField.shake()
                }
                if validationError.type == .password {
                    self.passwordTextField.shake()
                }
                return
            }
            self.showError(with: Strings.failure, message: error.displayString)
        }
        
        self.viewModel.didRegisterSuccess = { user in
            self.hideLoading()
            self.router.moveToHome {}
        }
    }
}

extension LoginViewController {
    @IBAction func didTapLoginButton(sender: UIButton) {
        guard let email = self.emailTextField.text, let password = self.passwordTextField.text else {
            fatalError("This can never be nil")
        }
        self.showLoading()
        self.viewModel.login(email: email, password: password)

    }
}
