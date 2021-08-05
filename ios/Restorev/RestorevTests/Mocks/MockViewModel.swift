//
//  MockViewModel.swift
//  RestorevTests
//
//  Created by Avismara Hugoppalu on 05/08/21.
//

import Foundation

fileprivate let reviewer = User(id: "1", name: "Test User", email: "test@gmail.com", role: .regular, token: "112341234")
fileprivate let trReview = Review(restaurantId: "1234", visitedDate: 12341234, rating: 3, ownerComment: "Nice", id: "6778", review: "Nice", reviewer: reviewer)
fileprivate let mcReview = Review(restaurantId: "1234", visitedDate: 12341234, rating: 3, ownerComment: "Nice", id: "6778", review: "Nice", reviewer: reviewer)
fileprivate let review = Review(restaurantId: "1234", visitedDate: 12341234, rating: 3, ownerComment: "Nice", id: "6778", review: "Nice", reviewer: reviewer)

class MockViewModel: RestaurantDetailViewModel {
    var didGetRestaurantDetail: (() -> ())?
    var didGetRestaurantDetailFail: ((ApplicationError) -> ())?
    
    var restaurantName: String = "Test"
    var restaurantId: String = "12345"
    
    var averageRating: Double = 5
    var numberOfReviews: Int  = 1
    
    var topRatedReview: Review! = trReview
    var mostCriticalReview: Review! = mcReview
    
    var topRatedReviewString: String = "Nice"
    var topRatedReviewId: String = "6778"
    var topReviewerName: String = "Test User"
    var topRatedRating: Int = 3
    var topRatedVisiteDate: Int = 12341234
    var topRatedOwnerComment: String? = "Nice"
    
    var mostCriticalReviewString: String = "Nice"
    var mostCriticalReviewId: String = "6778"
    var mostCriticalReviewerName: String = "Test User"
    var mostCriticalRating: Int = 3
    var mostCriticalVisiteDate: Int = 12341234
    var mostCriticalOwnerComment: String? = "Nice"
    
    func ratingAt(index: Int) -> Int {
        return 3
    }
    
    func reviewIdAt(index: Int) -> String {
        return "6778"
    }
    
    func reviewerNameAt(index: Int) -> String {
        return "Test User"
    }
    
    func visitedDateAt(index: Int) -> Int {
        return 12341234
    }
    
    func reviewAt(index: Int) -> String {
        return "Nice"
    }
    
    func commentAt(index: Int) -> String? {
        return "Nice"
    }
    
    func mReview(at index: Int) -> Review {
        return review
    }
    
    func getDetail() { }
}
