//
//  UINavigationController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

extension UINavigationController {
    static var restaurantsNavigation: UINavigationController {
        return UIStoryboard.restaurantsNavigation.instantiateInitialViewController() as! RestaurantsNavigationController
    }
}
