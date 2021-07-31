//
//  RegisterRoute.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

protocol LoginRouter: Router {
    func moveToHome()
}

final class LoginRouterImp: LoginRouter {
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    
    func moveToHome() {
        let viewController = RoleManager().viewControllerForPostLogin()
        viewController.modalPresentationStyle = .fullScreen
        self.navigatable?.present(viewController, animated: true, completion: nil)
    }
    
    weak var navigatable: Navigatable?
    
}
