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
    
    func postReview(review: String, rating: Int, visitedDate: Date)
}

class ReviewViewModelImp: ReviewViewModel {
    let restaurantId: String
    let restaurantName: String
    let service: RestaurantService
    
    var didPostReview: (() -> ())?
    var didPostReviewFail: ((ApplicationError) -> ())?
    
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
