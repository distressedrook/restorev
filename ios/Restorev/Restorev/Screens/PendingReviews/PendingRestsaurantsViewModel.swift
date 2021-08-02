//
//  PendingReviewViewModel.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import Foundation

protocol PendingRestaurantsViewModel {
    func getPendingRestaurants()
    
    func restaurantName(at index: Int) -> String
    func reviewAt(restaurantIndex: Int, reviewIndex: Int) -> Review
    var numberOfRestauranats: Int { get }
    func numberOfPendingReviews(at index: Int) -> Int
    
    var didFindPendingResaturants: (() -> ())? { get set }
    var didFindPendingRestaurantsFail: ((ApplicationError) -> ())? { get set }
}

final class PendingRestaurantsViewModelImp: PendingRestaurantsViewModel {
    var didFindPendingResaturants: (() -> ())?
    var didFindPendingRestaurantsFail: ((ApplicationError) -> ())?
    
    let service: ReviewService
    var pendingRestaurants: [PendingRestaurants]!
    
    var numberOfRestauranats: Int {
        return self.pendingRestaurants?.count ?? 0
    }
    
    init() {
        self.service = ReviewServiceImp()
    }
    
    init(service: ReviewService) {
        self.service = service
    }
    
    func restaurantName(at index: Int) -> String {
        return self.pendingRestaurants[index].restaurantName
    }
    
    func reviewAt(restaurantIndex: Int, reviewIndex: Int) -> Review {
        return self.pendingRestaurants[restaurantIndex].pendingReviews[reviewIndex]
    }
    func numberOfPendingReviews(at index: Int) -> Int {
        self.pendingRestaurants?[index].pendingReviews.count ?? 0
    }
    
    func getPendingRestaurants() {
        self.service.getPendingReviews { pendingReviews in
            self.pendingRestaurants = pendingReviews
            self.didFindPendingResaturants?()
        } failure: { error in
            self.didFindPendingRestaurantsFail?(error)
        }
    }
}
