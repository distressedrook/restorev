//
//  RegisterRoute.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

protocol LoginRouter: Router {
    
}

final class LoginRouterImp: LoginRouter {
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    
    weak var navigatable: Navigatable?
    
}
