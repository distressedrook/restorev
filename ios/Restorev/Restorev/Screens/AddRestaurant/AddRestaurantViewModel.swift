//
//  AddRestaurantViewModel.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import Foundation

protocol AddRestaurantViewModel {
    init(service: RestaurantService)
    
    var didPostRestaurant: (() -> ())? { get set }
    var didDeleteRestaurant: (() -> ())? { get set }
    var name: String { get }
    
    var didPostRestaurantFail: ((ApplicationError) -> ())? { get set }
    var didDeleteRestaurantFail: ((ApplicationError) -> ())? { get set }
    
    func postRestaurantName(name: String)
    func deleteRestaurant()
}

final class OwnerAddRestaurantViewModelImp: AddRestaurantViewModel {
    func deleteRestaurant() {
        fatalError("A owner cannot delete a restaurant")
    }
    
    let service: RestaurantService
    
    var name: String {
        return ""
    }
    
    var didPostRestaurant: (() -> ())?
    var didPostRestaurantFail: ((ApplicationError) -> ())?
    var didSetName: ((String) -> ())?
    var didDeleteRestaurant: (() -> ())?
    var didDeleteRestaurantFail: ((ApplicationError) -> ())?
    
    init() {
        self.service = RestaurantServiceImp()
    }
    
    init(service: RestaurantService) {
        self.service = service
    }
    
    func postRestaurantName(name: String) {
        if name.isEmpty {
            didPostRestaurantFail?(ValidationError(fieldType: .name))
            return
        }
        self.addRestaurant(with: name)
    }
    
    func addRestaurant(with name: String) {
        self.service.addRestaurant(with: name) {
            self.didPostRestaurant?()
        } failure: { error in
            self.didPostRestaurantFail?(error)
        }
    }
}

final class AdminAddRestaurantViewModelImp: AddRestaurantViewModel {
    var name: String {
        return restaurantName
    }
    let service: RestaurantService
    let restaurantId: String
    let restaurantName: String
    
    var didPostRestaurant: (() -> ())?
    var didPostRestaurantFail: ((ApplicationError) -> ())?
    var didSetName: ((String) -> ())?
    var didDeleteRestaurant: (() -> ())?
    var didDeleteRestaurantFail: ((ApplicationError) -> ())?
    
    init(restaurantId: String, restaurantName: String) {
        self.restaurantName = restaurantName
        self.restaurantId = restaurantId
        self.service = RestaurantServiceImp()
    }
    
    init(service: RestaurantService, restaurantId: String, restaurantName: String) {
        self.restaurantName = restaurantName
        self.restaurantId = restaurantId
        self.service = service
    }
    
    init(service: RestaurantService) {
        self.restaurantName = ""
        self.restaurantId = ""
        self.service = RestaurantServiceImp()
    }
    
    func deleteRestaurant() {
        self.service.deleteRestaurant(with: self.restaurantId) {
            self.didDeleteRestaurant?()
        } failure: { error in
            self.didDeleteRestaurantFail?(error)
        }
    }
    
    func postRestaurantName(name: String) {
        if name.isEmpty {
            didPostRestaurantFail?(ValidationError(fieldType: .name))
            return
        }
        self.addRestaurant(with: name)
    }
    
    func addRestaurant(with name: String) {
        self.service.editRestaurant(with:self.restaurantId, name: name) {
            self.didPostRestaurant?()
        } failure: { error in
            self.didPostRestaurantFail?(error)
        }
    }
}
