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
    
    static var pending: UIViewController {
        let viewController = UIStoryboard.pending.instantiateInitialViewController() as! PendingRestaurantsViewController
        viewController.viewModel = PendingRestaurantsViewModelImp()
        viewController.router = PendingRestaurantsRouterImp(navigatable: viewController)
        return viewController
    }
    
    static var users: UsersViewController {
        let viewController = UIStoryboard.users.instantiateInitialViewController() as! UsersViewController
        viewController.viewModel = UsersViewModelImp()
        viewController.router = UsersRouterImp(navigatable: viewController)
        return viewController
    }
    
    static var settings: UIViewController {
        let viewController = UIStoryboard.settings.instantiateInitialViewController() as! SettingsViewController
        viewController.router = SettingsRouterImp(navigatable: viewController)
        viewController.cache = CacheImp()
        return viewController
    }
    
    static func reviewViewController(with name: String, restaurantId: String, delegate: ReviewViewControllerDelegate? = nil) -> UIViewController {
        let viewController = UIStoryboard.review.instantiateInitialViewController() as! ReviewViewController
        viewController.viewModel = ReviewViewModelImp(restaurantId: restaurantId, restaurantName: name)
        viewController.delegate = delegate
        return viewController
    }
    
    static func reviewViewController(with name: String, restaurantId: String, review: Review, delegate: ReviewViewControllerDelegate? = nil) -> UIViewController {
        let viewController = UIStoryboard.review.instantiateInitialViewController() as! ReviewViewController
        viewController.viewModel = OwnerReviewViewModelImp(restaurantId: restaurantId, restaurantName: name, review: review)
        viewController.delegate = delegate
        return viewController
    }
    
    static func addRestaurantViewControllerWith(delegate: AddRestaurantViewControllerDelegate? = nil) -> UIViewController {
        let viewController = UIStoryboard.addRestaurant.instantiateInitialViewController() as! AddRestaurantViewController
        viewController.viewModel = OwnerAddRestaurantViewModelImp()
        viewController.delegate = delegate
        return viewController
    }
    
    static func editRestaurantViewControllerWith(restaurantId: String, restaurantName: String, delegate: AddRestaurantViewControllerDelegate? = nil) -> UIViewController {
        let viewController = UIStoryboard.addRestaurant.instantiateInitialViewController() as! AddRestaurantViewController
        viewController.viewModel = AdminAddRestaurantViewModelImp(restaurantId: restaurantId, restaurantName: restaurantName)
        viewController.delegate = delegate
        return viewController
    }
    
    static func commentViewControllerWith(review: Review, delegate: CommentViewControllerDelegate? = nil) -> UIViewController {
        let viewController = UIStoryboard.comment.instantiateInitialViewController() as! CommentViewController
        viewController.viewModel = OwnerCommentViewModeImp(review: review)
        viewController.delegate = delegate
        return viewController
    }
    
    static func editCommentViewControllerWith(review: Review, delegate: CommentViewControllerDelegate? = nil) -> UIViewController {
        let viewController = UIStoryboard.comment.instantiateInitialViewController() as! CommentViewController
        viewController.viewModel = AdminCommentViewModeImp(review: review)
        viewController.delegate = delegate
        return viewController
    }
    
    static func editUserViewControllerWith(userId: String, delegate: EditUserViewControllerDelegate? = nil) -> UIViewController {
        let viewController = UIStoryboard.editUser.instantiateInitialViewController() as! EditUserViewController
        viewController.viewModel = EditUserViewModelImp(userId: userId)
        viewController.delegate = delegate
        return viewController
    }
}
