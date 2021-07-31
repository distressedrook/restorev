//
//  RestaurantsRouter.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import Foundation

protocol RestaurantsRouter: Router {
    
}

final class RestaurantsRouterImp: RestaurantsRouter {
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    var navigatable: Navigatable?
    
    
}
