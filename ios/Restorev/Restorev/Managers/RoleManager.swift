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
            return UIViewController()
        case .owner:
            return UIViewController()
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
            return nil
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
        restaurantsTabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        restaurantsNavigationController.tabBarItem = restaurantsTabBarItem
        
        let settingsViewController = UIViewController()
        let settingsTabBarItem = UITabBarItem(title: nil, image: UIImage.restaurantsUnselected, selectedImage: UIImage.restaurantsSelected)
        settingsTabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        settingsViewController.tabBarItem = settingsTabBarItem
        
        controller.setViewControllers([restaurantsNavigationController, settingsViewController], animated: false)
        return controller
    }
}
