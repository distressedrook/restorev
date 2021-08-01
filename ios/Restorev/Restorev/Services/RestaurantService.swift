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
}

final class RestaurantServiceImp: RestaurantService {
    private let URL = Constants.BASE_URL + "/restaurants"
    private let DATA = "data"
    let serviceManager: ServiceManager
    
    init() {
        self.serviceManager = ServiceManagerImp()
    }
    
    init(serviceManager: ServiceManager) {
        self.serviceManager = serviceManager
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
}