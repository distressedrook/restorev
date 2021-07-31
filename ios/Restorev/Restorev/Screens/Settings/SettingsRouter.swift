//
//  SettingsRouter.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import Foundation

protocol SettingsRouter: Router {
    
}

final class SettingsRouterImp: SettingsRouter {
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    
    var navigatable: Navigatable?
    
    
}
