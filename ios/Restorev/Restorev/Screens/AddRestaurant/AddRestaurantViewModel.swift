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
    var didSetName: ((String) -> ())? { get set }
    var didPostRestaurantFail: ((ApplicationError) -> ())? { get set }
    
    func postRestaurantName(name: String)
}

final class OwnerAddRestaurantViewModelImp: AddRestaurantViewModel {
    let service: RestaurantService
    
    var didPostRestaurant: (() -> ())?
    var didPostRestaurantFail: ((ApplicationError) -> ())?
    var didSetName: ((String) -> ())?
    
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
