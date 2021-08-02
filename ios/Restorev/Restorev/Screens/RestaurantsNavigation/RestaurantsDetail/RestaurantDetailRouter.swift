//
//  RestaurantDetailRoute.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 01/08/21.
//

import UIKit

protocol RestaurantDetailRouter: Router {
    func moveToReview(restaurantName: String, restaurantId: String, delegate: ReviewViewControllerDelegate?)
    func moveToComment(review: Review, delegate: CommentViewControllerDelegate?)
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
    
    func moveToComment(review: Review, delegate: CommentViewControllerDelegate?) {
        let commentViewController = UIViewController.commentViewControllerWith(review: review, delegate: delegate)
        self.navigatable?.present(commentViewController, animated: true, completion: nil)
    }
    
    func moveToEdit() {
        
    }
    
    var navigatable: Navigatable?
    
    
}
