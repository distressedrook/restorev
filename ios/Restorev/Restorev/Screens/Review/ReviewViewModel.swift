//
//  ReviewViewModel.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 01/08/21.
//

import Foundation

protocol ReviewViewModel {
    
    var didPostReview: (() -> ())? { get set }
    var didPostReviewFail: ((ApplicationError) -> ())? { get set }
    var didDeleteReview: (() -> ())? { get set }
    var didDeleteReviewFail: ((ApplicationError) -> ())? { get set }
    
    func deleteReview()
    func postReview(review: String, rating: Int, visitedDate: Date)
    
    var rating: Int { get }
    var date: Date { get }
    var review: String { get }
    
}

class ReviewViewModelImp: ReviewViewModel {
    let restaurantId: String
    let restaurantName: String
    let service: RestaurantService
    
    
    var didPostReview: (() -> ())?
    var didPostReviewFail: ((ApplicationError) -> ())?
    var didDeleteReview: (() -> ())?
    var didDeleteReviewFail: ((ApplicationError) -> ())?
    
    var rating: Int {
        return 0
    }
    
    var date: Date {
        return Date()
    }
    
    var review: String {
        return ""
    }
    
    init(restaurantId: String, restaurantName: String, service: RestaurantService) {
        self.restaurantId = restaurantId
        self.service = service
        self.restaurantName = restaurantName
    }
    init(restaurantId:String , restaurantName: String) {
        self.restaurantId = restaurantId
        self.service = RestaurantServiceImp()
        self.restaurantName = restaurantName
    }
    
    func deleteReview() {}
    
    func postReview(review: String, rating: Int, visitedDate: Date) {
        let visitedDateEpoch = Int(visitedDate.timeIntervalSince1970)
        if !validate(review: review, rating: rating, visitedDate: visitedDateEpoch) {
            return
        }
        self.service.addReview(review: review, rating: rating, visitedDate: Int(visitedDate.timeIntervalSince1970), to: restaurantId) { [weak self ] in
            self?.didPostReview?()
        } failure: { [weak self] error in
            self?.didPostReviewFail?(error)
        }
    }
    
    func validate(review: String, rating: Int, visitedDate: Int) -> Bool {
        var validated = true
        if review.isEmpty {
            let error = ValidationError(fieldType: .review)
            didPostReviewFail?(error)
            validated = false
        }
        if rating == 0 {
            let error = ValidationError(fieldType: .rating)
            didPostReviewFail?(error)
            validated = false
        }
        return validated
    }
    
}

class OwnerReviewViewModelImp: ReviewViewModel {
    let restaurantId: String
    let restaurantName: String
    let service: ReviewService
    var mReview: Review
    
    var didPostReview: (() -> ())?
    var didPostReviewFail: ((ApplicationError) -> ())?
    var didDeleteReview: (() -> ())?
    var didDeleteReviewFail: ((ApplicationError) -> ())?
    
    var rating: Int {
        return self.mReview.rating
    }
    
    
    var review: String {
        return self.mReview.review
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(self.mReview.visitedDate))
    }
    
    
    init(restaurantId: String, restaurantName: String, review: Review, service: ReviewService) {
        self.restaurantId = restaurantId
        self.service = service
        self.restaurantName = restaurantName
        self.mReview = review
    }
    init(restaurantId:String , restaurantName: String, review: Review) {
        self.restaurantId = restaurantId
        self.service = ReviewServiceImp()
        self.restaurantName = restaurantName
        self.mReview = review
    }
    
    func postReview(review: String, rating: Int, visitedDate: Date) {
        let visitedDateEpoch = Int(visitedDate.timeIntervalSince1970)
        if !validate(review: review, rating: rating, visitedDate: visitedDateEpoch) {
            return
        }
        self.service.editReviewWith(reviewId:self.mReview.id!, rating: rating, visitedDate: Int(visitedDate.timeIntervalSince1970), review: review) { [weak self ] in
            self?.didPostReview?()
        } failure: { [weak self] error in
            self?.didPostReviewFail?(error)
        }
    }
    
    func deleteReview() {
        self.service.deleteReviewWith(reviewId: self.mReview.id!) { [weak self ] in
            self?.didDeleteReview?()
        } failure: { [weak self] error in
            self?.didDeleteReviewFail?(error)
        }
    }
    
    func validate(review: String, rating: Int, visitedDate: Int) -> Bool {
        var validated = true
        if review.isEmpty {
            let error = ValidationError(fieldType: .review)
            didPostReviewFail?(error)
            validated = false
        }
        if rating == 0 {
            let error = ValidationError(fieldType: .rating)
            didPostReviewFail?(error)
            validated = false
        }
        return validated
    }
    
}
