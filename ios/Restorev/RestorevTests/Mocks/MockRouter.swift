//
//  MockRouter.swift
//  RestorevTests
//
//  Created by Avismara Hugoppalu on 05/08/21.
//

import Foundation

class MockRouter: RestaurantDetailRouter {
    var didCallMoveToComment: ((Review) -> ())?
    
    required init(navigatable: Navigatable) { }
    var navigatable: Navigatable?
    
    func dismiss(completion: (() -> Void)?) { }
    
    func moveToReview(restaurantName: String, restaurantId: String, delegate: ReviewViewControllerDelegate?) { }
    
    func moveToComment(review: Review, delegate: CommentViewControllerDelegate?) {
        self.didCallMoveToComment?(review)
    }
    
    func moveToEditWith(restaurantId: String, restaurantName: String, delegate: AddRestaurantViewControllerDelegate) { }
    func moveToEditReviewWith(restaurantId: String, restaurantName: String, review: Review, delegate: ReviewViewControllerDelegate) { }
    func moveToEditCommentWith(review: Review, delegate: CommentViewControllerDelegate) { }
    func pop() { }
}
