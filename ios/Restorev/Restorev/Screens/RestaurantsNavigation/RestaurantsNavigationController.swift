//
//  RestaurantsNavigationController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

class RestaurantsNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.backgroundWhite, NSAttributedString.Key.font: UIFont.openSansBold(with: 17)]
    }

}


