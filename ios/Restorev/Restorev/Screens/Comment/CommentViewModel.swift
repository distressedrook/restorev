//
//  CommentViewModel.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import Foundation


protocol CommentViewModel {
    
    init(review: Review, service: ReviewService)
    init(review: Review)
    
    var reviewerName: String { get }
    var reviewRating: Int { get }
    var reviewerVisitedDate: Int { get }
    var review: String { get }
    func postComment(comment: String)
    var didPostComment: (() -> ())? { get set }
    var didPostCommentFail: ((ApplicationError) -> ())? { get set }
}

final class OwnerCommentViewModeImp: CommentViewModel {
    var reviewerName: String {
        return self.mReview.reviewer?.name ?? ""
    }
    
    var reviewRating: Int {
        return self.mReview.rating
    }
    
    var reviewerVisitedDate: Int {
        self.mReview.visitedDate
    }
    
    var review: String {
        self.mReview.review
    }
    
    func postComment(comment: String) {
        guard let reviewId = self.mReview.id else {
            fatalError("reviewId should exist")
        }
        self.service.commentToReviewWith(reviewId: reviewId, comment: comment) {
            self.didPostComment?()
        } failure: { error in
            self.didPostCommentFail?(error)
        }
    }
    
    var didPostComment: (() -> ())?
    
    var didPostCommentFail: ((ApplicationError) -> ())?
    
    let mReview: Review
    let service: ReviewService
    init(review: Review, service: ReviewService) {
        self.mReview = review
        self.service = service
    }
    init(review: Review) {
        self.mReview = review
        self.service = ReviewServiceImp()
    }
}