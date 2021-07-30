//
//  LandingRouter.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

protocol LandingRouter: Router {
    func routeToLogin()
    func routeToRegister(with delegate: RegisterViewControllerDelegate?)
}

final class LandingRouterImp: LandingRouter {
    weak var navigatable: Navigatable?
    
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    
    func routeToLogin() {
        self.navigatable?.present(UIViewController.login, animated: true, completion: nil)
    }
    
    func routeToRegister(with delegate: RegisterViewControllerDelegate?) {
        self.navigatable?.present(UIViewController.register(with: delegate), animated: true, completion: nil)
    }
}
