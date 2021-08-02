//
//  RestaurantService.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import Foundation

protocol RestaurantService {
    init()
    init(serviceManager: ServiceManager)
    func getAllRestaurants(success: @escaping ([Restaurant]) -> (), failure: @escaping (ApplicationError) -> ())
    func getAllRestaurants(of ownerId: String, success: @escaping ([Restaurant]) -> (), failure: @escaping (ApplicationError) -> ())
    func getRestaurant(with id: String, success: @escaping (Restaurant) -> (), failure: @escaping (ApplicationError) -> ())
    func addRestaurant(with name: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ())
    func addReview(review: String, rating: Int, visitedDate: Int, to restauarntId: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ())
}

final class RestaurantServiceImp: RestaurantService {
    private let URL = Constants.BASE_URL + "/restaurants"
    private let DATA = "data"
    private let NAME = "name"
    let serviceManager: ServiceManager
    
    init() {
        self.serviceManager = ServiceManagerImp()
    }
    
    init(serviceManager: ServiceManager) {
        self.serviceManager = serviceManager
    }
    
    func addRestaurant(with name: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.post(with: URL + "/add", parameters: [NAME: name], headers: authTokenHeader()) { response in
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func getAllRestaurants(of ownerId: String, success: @escaping ([Restaurant]) -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.get(with: URL + "/owner/\(ownerId)", parameters: [String:String](), headers: authTokenHeader()) { [weak self] response in
            guard let self = self else {
                return
            }
            guard let data = response[self.DATA] as? [[String: Any]] else {
                fatalError("API is not behaving as expected")
            }
            do {
                let restaurants = try parse(with: data, to: Restaurant.self)
                success(restaurants)
            } catch {
                fatalError("API is not behaving as expected")
            }
        } failure: { error in
            failure(error)
        }
    }
    
    func getAllRestaurants(success: @escaping ([Restaurant]) -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.get(with: URL, parameters: [String:String](), headers: authTokenHeader()) { [weak self] response in
            guard let self = self else {
                return
            }
            guard let data = response[self.DATA] as? [[String: Any]] else {
                fatalError("API is not behaving as expected")
            }
            do {
                let restaurants = try parse(with: data, to: Restaurant.self)
                success(restaurants)
            } catch {
                fatalError("API is not behaving as expected")
            }
        } failure: { error in
            failure(error)
        }
    }
    
    func addReview(review: String, rating: Int, visitedDate: Int, to restauarntId: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> () ) {
        class Review: Codable {
            let review: String
            let rating: Int
            let visitedDate: Int
            init(review: String, rating: Int, visitedDate: Int) {
                self.visitedDate = visitedDate
                self.review = review
                self.rating = rating
            }
        }
        let review = Review(review: review, rating: rating, visitedDate: visitedDate)
        self.serviceManager.post(with: URL + "/\(restauarntId)/addReview", parameters: review, headers: authTokenHeader()) { response in
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func getRestaurant(with id: String, success: @escaping (Restaurant) -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.get(with: URL + "/\(id)", parameters: [String:String](), headers: authTokenHeader()) { [weak self] response in
            guard let self = self else {
                return
            }
            guard let data = response[self.DATA] as? [String: Any] else {
                fatalError("API is not behaving as expected")
            }
            do {
                let restaurant = try map(json: data, to: Restaurant.self)
                success(restaurant)
            } catch {
                fatalError("API is not behaving as expected")
            }
        } failure: { error in
            failure(error)
        }
    }
    
    
}
