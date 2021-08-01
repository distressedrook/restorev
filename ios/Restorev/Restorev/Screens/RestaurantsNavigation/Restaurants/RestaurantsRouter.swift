//
//  RestaurantsRouter.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import Foundation
import UIKit
protocol RestaurantsRouter: Router {
    func moveToRestaurantDetailWith(id: String)
    func prepareToMoveTo(viewController: UIViewController, id: String)
}

final class RestaurantsRouterImp: RestaurantsRouter {
    func prepareToMoveTo(viewController: UIViewController, id: String) {
        let vc = viewController as! RestaurantDetailViewController
        vc.viewModel = RestaurantDetailViewModelImp(id: id)
        vc.router = RestaurantDetailRouterImp(navigatable: viewController)
        
    }
    
    init(navigatable: Navigatable) {
        self.navigatable = navigatable
    }
    var navigatable: Navigatable?
    
    func moveToRestaurantDetailWith(id: String) {
        self.navigatable?.performSegue(withIdentifier: "showRestaurantDetail", sender: id)
    }
    
}
