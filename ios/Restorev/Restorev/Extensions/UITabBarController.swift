//
//  UITabBarController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

extension UITabBarController {
    static var homeTab: UITabBarController {
        let viewController = UIStoryboard.homeTab.instantiateInitialViewController() as! HomeTabBarController
        return viewController
    }
}
