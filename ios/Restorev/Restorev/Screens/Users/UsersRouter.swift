//
//  UsersRouter.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import UIKit

protocol UsersRouter: Router {
    func moveToEditUserWith(userId: String, delegate: EditUserViewControllerDelegate?)
}

class UsersRouterImp: UsersRouter {
    required init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    var navigatable: Navigatable?
    
    func moveToEditUserWith(userId: String, delegate: EditUserViewControllerDelegate? = nil) {
        let viewController = UIViewController.editUserViewControllerWith(userId: userId, delegate: delegate)
        self.navigatable?.present(viewController, animated: true, completion: nil)
    }
    
}
