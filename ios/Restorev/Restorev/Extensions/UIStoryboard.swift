//
//  UIStoryboard.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

extension UIStoryboard {
    static var register: UIStoryboard {
        return UIStoryboard(name: "RegisterViewController", bundle: nil)
    }
    
    static var login: UIStoryboard {
        return UIStoryboard(name: "LoginViewController", bundle: nil)
    }
    
    static var landing: UIStoryboard {
        return UIStoryboard(name: "LandingViewController", bundle: nil)
    }
    
    static var homeTab: UIStoryboard {
        return UIStoryboard(name: "HomeTabBarController", bundle: nil)
    }
    
    static var restaurants: UIStoryboard {
        return UIStoryboard(name: "RestaurantsViewController", bundle: nil)
    }
    
    static var pending: UIStoryboard {
        return UIStoryboard(name: "PendingRestaurantsViewController", bundle: nil)
    }
    
    static var restaurantsNavigation: UIStoryboard {
        return UIStoryboard(name: "RestaurantsNavigationController", bundle: nil)
    }
    
    static var settings: UIStoryboard {
        return UIStoryboard(name: "SettingsViewController", bundle: nil)
    }
    
    static var addRestaurant: UIStoryboard {
        return UIStoryboard(name: "AddRestaurantViewController", bundle: nil)
    }
    
    static var review: UIStoryboard {
        return UIStoryboard(name: "ReviewViewController", bundle: nil)
    }
    
    static var comment: UIStoryboard {
        return UIStoryboard(name: "CommentViewController", bundle: nil)
    }
    
    static var users: UIStoryboard {
        return UIStoryboard(name: "UsersViewController", bundle: nil)
    }
    
    static var editUser: UIStoryboard {
        return UIStoryboard(name: "EditUserViewController", bundle: nil)
    }
}
