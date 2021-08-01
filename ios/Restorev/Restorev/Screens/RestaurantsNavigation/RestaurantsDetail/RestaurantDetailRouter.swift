//
//  RestaurantDetailRoute.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 01/08/21.
//

import Foundation

protocol RestaurantDetailRouter: Router {
    func moveToReview()
    func moveToEdit()
}

final class RestaurantDetailRouterImp: RestaurantDetailRouter {
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    
    func moveToReview() {
        
    }
    
    func moveToEdit() {
        
    }
    
    var navigatable: Navigatable?
    
    
}
