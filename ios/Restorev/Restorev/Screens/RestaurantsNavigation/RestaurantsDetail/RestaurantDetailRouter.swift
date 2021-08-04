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
    func moveToEditWith(restaurantId: String, restaurantName: String, delegate: AddRestaurantViewControllerDelegate)
    func moveToEditReviewWith(restaurantId: String, restaurantName: String, review: Review, delegate: ReviewViewControllerDelegate)
    func moveToEditCommentWith(review: Review, delegate: CommentViewControllerDelegate)
    func pop()
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
    
    func moveToEditWith(restaurantId: String, restaurantName: String, delegate: AddRestaurantViewControllerDelegate) {
        let editRestaurantsViewController = UIViewController.editRestaurantViewControllerWith(restaurantId: restaurantId, restaurantName: restaurantName, delegate: delegate)
        self.navigatable?.present(editRestaurantsViewController, animated: true, completion: nil)
    }
    
    func moveToEditCommentWith(review: Review, delegate: CommentViewControllerDelegate) {
        let commentViewController = UIViewController.editCommentViewControllerWith(review: review, delegate: delegate)
        self.navigatable?.present(commentViewController, animated: true, completion: nil)
    }
    
    func moveToEditReviewWith(restaurantId: String, restaurantName: String, review: Review, delegate: ReviewViewControllerDelegate) {
        let editRestaurantsViewController = UIViewController.reviewViewController(with: restaurantName, restaurantId: restaurantId, review: review, delegate: delegate)
        self.navigatable?.present(editRestaurantsViewController, animated: true, completion: nil)
    }
    
    func pop() {
        self.navigatable?.navigationController?.popViewController(animated: true)
    }
    
    var navigatable: Navigatable?
    
    
}
