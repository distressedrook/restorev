//
//  RestaurantDetailRoute.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 01/08/21.
//

import UIKit

protocol RestaurantDetailRouter: Router {
    func moveToReview(restaurantName: String, restaurantId: String, delegate: ReviewViewControllerDelegate?) 
    func moveToEdit()
}

final class RestaurantDetailRouterImp: RestaurantDetailRouter {
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    
    func moveToReview(restaurantName: String, restaurantId: String, delegate: ReviewViewControllerDelegate? = nil) {
        let reviewViewController = UIViewController.reviewViewController(with: restaurantName, restaurantId: restaurantId, delegate: delegate)
        self.navigatable?.present(reviewViewController, animated: true, completion: nil)
    }
    
    func moveToEdit() {
        
    }
    
    var navigatable: Navigatable?
    
    
}
