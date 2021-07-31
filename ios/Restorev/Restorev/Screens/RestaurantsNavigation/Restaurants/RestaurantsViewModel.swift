//
//  RestaurantsViewModel.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import Foundation

protocol RestaurantsViewModel {
    init()
    init(restaurantService: RestaurantService)
    
    var numberOfRestaurants: Int { get }
    func name(at index: Int) -> String
    func id(at index: Int) -> String
    func averageRating(at index: Int) -> Double
    
    var didGetRestaurants: (() -> ())? { get set }
    var didGetRestaurantFail: ((ApplicationError) -> ())? { get set }
    
    func getRestaurants()
}

final class RestaurantsViewModelImp: RestaurantsViewModel {
    
    private var restaurants = [Restaurant]()
    
    let restaurantService: RestaurantService
    
    var didGetRestaurants: (() -> ())?
    var didGetRestaurantFail: ((ApplicationError) -> ())?
    
    init() {
        self.restaurantService = RestaurantServiceImp()
    }
    
    init(restaurantService: RestaurantService) {
        self.restaurantService = restaurantService
    }
    
    var numberOfRestaurants: Int {
        return self.restaurants.count
    }
    
    func name(at index: Int) -> String {
        return self.restaurants[index].name
    }
    
    func id(at index: Int) -> String {
        return self.restaurants[index].id
    }
    
    func averageRating(at index: Int) -> Double {
        return self.restaurants[index].averageRating
    }
    
    func getRestaurants() {
        self.restaurantService.getAllRestaurants { [weak self] restaurants in
            self?.restaurants = restaurants
            self?.didGetRestaurants?()
        } failure: { [weak self] error in
            self?.didGetRestaurantFail?(error)
        }
    }
}
