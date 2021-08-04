//
//  RestaurantDetailViewModel.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 01/08/21.
//

import Foundation

protocol RestaurantDetailViewModel {
    init(id: String, service: RestaurantService)
    init(id: String)
    
    var didGetRestaurantDetail: (() -> ())? { get set }
    var didGetRestaurantDetailFail:((ApplicationError) -> ())? { get set }
    var restaurantName: String { get }
    var restaurantId: String { get }
    var averageRating: Double { get }
    var numberOfReviews: Int { get }
    
    var topRatedReview: Review! { get }
    var mostCriticalReview: Review! { get }
    
    var topRatedReviewString: String { get }
    var topRatedReviewId: String { get }
    var topReviewerName: String { get }
    var topRatedRating: Int { get }
    var topRatedVisiteDate: Int { get }
    var topRatedOwnerComment: String? { get}
    
    var mostCriticalReviewString: String { get }
    var mostCriticalReviewId: String { get }
    var mostCriticalReviewerName: String { get }
    var mostCriticalRating: Int { get }
    var mostCriticalVisiteDate: Int { get }
    var mostCriticalOwnerComment: String? { get }
    
    func ratingAt(index: Int) -> Int
    func reviewIdAt(index: Int) -> String
    func reviewerNameAt(index: Int) -> String
    func visitedDateAt(index: Int) -> Int
    func reviewAt(index: Int) -> String
    func commentAt(index: Int) -> String?
    func mReview(at index: Int) -> Review
    
    func getDetail()
}

final class RestaurantDetailViewModelImp: RestaurantDetailViewModel {
    let id: String
    var restaurant: Restaurant!
    let service: RestaurantService
    
    var didGetRestaurantDetail: (() -> ())?
    var didGetRestaurantDetailFail:((ApplicationError) -> ())?
    var restaurantName: String {
        return self.restaurant.name
    }
    var restaurantId: String {
        return self.restaurant.id
    }
    var averageRating: Double {
        return self.restaurant.averageRating
    }
    
    var topRatedReviewId: String {
        return self.topRatedReview.id ?? ""
    }
    
    var numberOfReviews: Int {
        return self.restaurant?.reviews?.count ?? 0
    }
    
    func reviewIdAt(index: Int) -> String {
        return self.restaurant.reviews![index].id ?? ""
    }
    
    func ratingAt(index: Int) -> Int {
        return self.restaurant.reviews![index].rating
    }
    
    func reviewerNameAt(index: Int) -> String {
        return self.restaurant.reviews![index].reviewer!.name
    }
    
    func visitedDateAt(index: Int) -> Int {
        return self.restaurant.reviews![index].visitedDate
    }
    
    func reviewAt(index: Int) -> String {
        return self.restaurant.reviews![index].review
    }
    
    func commentAt(index: Int) -> String? {
        return self.restaurant.reviews![index].ownerComment
    }
    
    func mReview(at index: Int) -> Review {
        return self.restaurant.reviews![index]
    }
    
    var topRatedReview: Review!
    var mostCriticalReview: Review!
    
    var topRatedReviewString: String {
        self.topRatedReview.review
    }
    
    var topReviewerName: String {
        return self.topRatedReview.reviewer!.name
    }
    
    var topRatedRating: Int {
        return self.topRatedReview.rating
    }
    
    var topRatedVisiteDate: Int {
        return self.topRatedReview.visitedDate
    }
    
    var topRatedOwnerComment: String? {
        return self.topRatedReview.ownerComment
    }
    
    var mostCriticalReviewString: String {
        self.mostCriticalReview.review
    }
    
    var mostCriticalReviewerName: String {
        return self.mostCriticalReview.reviewer!.name
    }
    
    var mostCriticalReviewId: String {
        return self.mostCriticalReview.id ?? ""
    }
    
    var mostCriticalRating: Int {
        return self.mostCriticalReview.rating
    }
    
    var mostCriticalVisiteDate: Int {
        return self.mostCriticalReview.visitedDate
    }
    
    var mostCriticalOwnerComment: String? {
        return self.mostCriticalReview.ownerComment
    }
    
    init(id: String, service: RestaurantService) {
        self.id = id
        self.service = service
    }
    init(id: String) {
        self.id = id
        self.service = RestaurantServiceImp()
    }
    
    func getDetail() {
        self.service.getRestaurant(with: id) { [weak self] restaurant in
            var topRatedReview: Review!
            var topRating: Int = 0
            
            var mostCriticalReview: Review!
            var mostCritialRating: Int = 5
            for review in restaurant.reviews ?? [] {
                if topRating <= review.rating {
                    topRating = review.rating
                    topRatedReview = review
                }
                if mostCritialRating >= review.rating {
                    mostCriticalReview = review
                    mostCritialRating = review.rating
                }
            }
            self?.topRatedReview = topRatedReview
            self?.mostCriticalReview  = mostCriticalReview
            self?.restaurant = restaurant
            self?.didGetRestaurantDetail?()
        } failure: { [weak self] error in
            self?.didGetRestaurantDetailFail?(error)
        }
    }
}


