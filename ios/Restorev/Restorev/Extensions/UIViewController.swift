//
//  UIViewController.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

extension UIViewController {
    static var login: UIViewController {
        let viewController = UIStoryboard.login.instantiateInitialViewController() as! LoginViewController
        viewController.viewModel = LoginViewModelImp()
        viewController.router = LoginRouterImp(navigatable: viewController)
        return viewController
    }
    
    static var landing: UIViewController {
        let viewController = UIStoryboard.landing.instantiateInitialViewController() as! LandingViewController
        viewController.router = LandingRouterImp(navigatable: viewController)
        return viewController
    }
    
    static func register(with delegate: RegisterViewControllerDelegate? = nil) -> RegisterViewController {
        let viewController = UIStoryboard.register.instantiateInitialViewController() as! RegisterViewController
        viewController.delegate = delegate
        viewController.viewModel = RegisterViewModelImp()
        viewController.router = RegisterRouterImp(navigatable: viewController)
        return viewController
    }
    
    static var restaurants: UIViewController {
        let viewController = UIStoryboard.restaurants.instantiateInitialViewController() as! RestaurantsViewController
        viewController.viewModel = RestaurantsViewModelImp()
        viewController.router = RestaurantsRouterImp(navigatable: viewController)
        return viewController
    }
    
    static var settings: UIViewController {
        let viewController = UIStoryboard.settings.instantiateInitialViewController() as! SettingsViewController
        viewController.router = SettingsRouterImp(navigatable: viewController)
        return viewController
    }
}
