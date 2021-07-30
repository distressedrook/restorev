//
//  ViewController.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit
import SwiftMessages

class LandingViewController: UIViewController, MessageDisplayable {

    var router: LandingRouter!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.router = LandingRouterImp(navigatable: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension LandingViewController {
    @IBAction func didTapLoginButton(sender: UIButton) {
        self.router.routeToLogin()
    }
    
    @IBAction func didTapRegisterButton(sender: UIButton) {
        self.router.routeToRegister(with: self)
    }
}

extension LandingViewController: RegisterViewControllerDelegate {
    func didFinishRegisterIn(registerViewController: RegisterViewController) {
        self.showSuccess(with: Strings.success, message: Strings.accountCreated)
    }
}

