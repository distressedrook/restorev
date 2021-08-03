//
//  RoleManager.swift
//  Restorev
//
//  Created by Avismara HL on 30/07/21.
//

import UIKit

class RoleManager {
    let cache: Cache
    init() {
        self.cache = CacheImp()
    }
    
    init(cache: Cache) {
        self.cache = cache
    }
    
    func viewControllerForLaunch() -> UIViewController {
        guard self.cache.user?.role != nil else {
            return UIViewController.landing
        }
        return viewControllerForPostLogin()
    }
    
    func viewControllerForPostLogin() -> UIViewController {
        guard let role = self.cache.user?.role else {
            fatalError("User is not logged in. Use this method only after the user has logged in.")
        }
        switch role {
        case .regular:
            return viewControllerForRegular()
        case .admin:
            return viewControllerForAdmin()
        case .owner:
            return viewControllerForOwner()
        }
    }
    
    func restaurantsServiceFor(viewModel: RestaurantsViewModel) -> (() -> ()) {
        guard let role = self.cache.user?.role else {
            fatalError("User is not logged in. Use this method only after the user has logged in.")
        }
        switch role {
        case .regular:
            return viewModel.getAllRestaurants
        case .admin:
            return viewModel.getAllRestaurants
        case .owner:
            return viewModel.getRestaurantsForUser
        }
    }
    
    func barButtonItemFor(restaurantViewController: RestaurantsViewController) -> UIBarButtonItem? {
        guard let role = self.cache.user?.role else {
            fatalError("User is not logged in. Use this method only after the user has logged in.")
        }
        switch role {
        case .regular:
            return nil
        case .admin:
            return nil
        case .owner:
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: restaurantViewController, action: #selector(RestaurantsViewController.didTapAddButton(sender:)))
            barButtonItem.tintColor = UIColor.white
            return barButtonItem
        }
    }
    
    func nibNameForReviewTableViewCell() -> String {
        guard let role = self.cache.user?.role else {
            fatalError("User is not logged in. Use this method only after the user has logged in.")
        }
        switch role {
        case .regular:
            return "ReguarReviewTableViewCell"
        case .admin:
            return "AdminReviewTableViewCell"
        case .owner:
            return "OwnerReviewTableViewCell"
        }
    }
    
    func messageForPostRestaurantName() -> String {
        guard let role = self.cache.user?.role else {
            fatalError("User is not logged in. Use this method only after the user has logged in.")
        }
        switch role {
        case .regular:
            fatalError("Should never come here")
        case .admin:
            return Strings.restaurantEdited
        case .owner:
            return Strings.restaurantCreated
        }
    }
    
    func rightBarButtonItemFor(restaurantDetailViewController: RestaurantDetailViewController) -> UIBarButtonItem? {
        guard let role = self.cache.user?.role else {
            fatalError("User is not logged in. Use this method only after the user has logged in.")
        }
        switch role {
        case .regular:
            let barButtonItem = UIBarButtonItem(title: Strings.review, style: .plain, target: restaurantDetailViewController, action: #selector(RestaurantDetailViewController.didTapReviewButton(sender:)))
            barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.openSansBold(with: 15)], for: .normal)
            barButtonItem.tintColor = UIColor.white
            return barButtonItem
        case .admin:
            let barButtonItem = UIBarButtonItem(title: Strings.edit, style: .plain, target: restaurantDetailViewController, action: #selector(RestaurantDetailViewController.didTapReviewButton(sender:)))
            barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.openSansBold(with: 15)], for: .normal)
            barButtonItem.tintColor = UIColor.white
            return barButtonItem
        case .owner:
            return nil
        }
    }
    
    func commentTitleLabelForRestaurant(name: String) -> String {
        guard let role = self.cache.user?.role else {
            fatalError("User is not logged in. Use this method only after the user has logged in.")
        }
        switch role {
        case .regular:
            return "\(name) \(Strings.commented)"
        case .admin:
            return "\(name) \(Strings.commented)"
        case .owner:
            return Strings.youCommented
        }
    }
    
    private func viewControllerForRegular() -> UIViewController {
        let controller = UITabBarController.homeTab
        
        let restaurantsNavigationController = UINavigationController.restaurantsNavigation
        let restaurantsTabBarItem = UITabBarItem(title: nil, image: UIImage.restaurantsUnselected, selectedImage: UIImage.restaurantsSelected)
        restaurantsTabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -10, right: 0)
        restaurantsNavigationController.tabBarItem = restaurantsTabBarItem
        
        let settingsViewController = UIViewController.settings
        let settingsTabBarItem = UITabBarItem(title: nil, image: UIImage.settingsUnselected, selectedImage: UIImage.settingsSelected)
        settingsTabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        settingsViewController.tabBarItem = settingsTabBarItem
        
        controller.setViewControllers([restaurantsNavigationController, settingsViewController], animated: false)
        return controller
    }
    
    private func viewControllerForOwner() -> UIViewController {
        let controller = UITabBarController.homeTab
        
        let restaurantsNavigationController = UINavigationController.restaurantsNavigation
        let restaurantsTabBarItem = UITabBarItem(title: nil, image: UIImage.restaurantsUnselected, selectedImage: UIImage.restaurantsSelected)
        restaurantsTabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -10, right: 0)
        restaurantsNavigationController.tabBarItem = restaurantsTabBarItem
        
        let settingsViewController = UIViewController.settings
        let settingsTabBarItem = UITabBarItem(title: nil, image: UIImage.settingsUnselected, selectedImage: UIImage.settingsSelected)
        settingsTabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        settingsViewController.tabBarItem = settingsTabBarItem
        
        let pendingRestaurantsViewController = UIViewController.pending
        let pendingTabBarItem = UITabBarItem(title: nil, image: UIImage.pendingUnselected, selectedImage: UIImage.pendingSelected)
        pendingTabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        pendingRestaurantsViewController.tabBarItem = pendingTabBarItem
        
        controller.setViewControllers([restaurantsNavigationController, pendingRestaurantsViewController, settingsViewController], animated: false)
        return controller
    }
    
    private func viewControllerForAdmin() -> UIViewController {
        let controller = UITabBarController.homeTab
        
        let restaurantsNavigationController = UINavigationController.restaurantsNavigation
        let restaurantsTabBarItem = UITabBarItem(title: nil, image: UIImage.restaurantsUnselected, selectedImage: UIImage.restaurantsSelected)
        restaurantsTabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -10, right: 0)
        restaurantsNavigationController.tabBarItem = restaurantsTabBarItem
        
        let settingsViewController = UIViewController.settings
        let settingsTabBarItem = UITabBarItem(title: nil, image: UIImage.settingsUnselected, selectedImage: UIImage.settingsSelected)
        settingsTabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        settingsViewController.tabBarItem = settingsTabBarItem
        
        let usersViewController = UIViewController.users
        let usersTabBarItem = UITabBarItem(title: nil, image: UIImage.userUnselected, selectedImage: UIImage.userSelected)
        usersTabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -10, right: 0)
        usersViewController.tabBarItem = usersTabBarItem
        
        controller.setViewControllers([usersViewController, restaurantsNavigationController, settingsViewController], animated: false)
        return controller
    }
}
