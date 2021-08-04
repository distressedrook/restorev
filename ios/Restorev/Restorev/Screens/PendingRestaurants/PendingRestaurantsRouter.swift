//
//  PendingRestaurantsRouter.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import UIKit

protocol PendingRestaurantsRouter: Router {
    func moveToComment(review: Review, delegate: CommentViewControllerDelegate)
}

class PendingRestaurantsRouterImp: PendingRestaurantsRouter {
    required init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    
    var navigatable: Navigatable?
    
    func moveToComment(review: Review, delegate: CommentViewControllerDelegate) {
        let viewController = UIViewController.commentViewControllerWith(review: review, delegate: delegate)
        self.navigatable?.present(viewController, animated: true, completion: nil)
    }
    
}
