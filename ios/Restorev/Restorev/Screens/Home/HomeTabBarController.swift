//
//  HomeTabBarViewController.swift
//  Restorev
//
//  Created by Avismara HL on 30/07/21.
//

import UIKit

class HomeTabBarController: UITabBarController {
    private let BAR_HEIGHT: CGFloat = 70
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setTabBarHeight()
        
    }
    
    private func setTabBarHeight() {
        let bottomSafeHeight = UIApplication.shared.windows[0].safeAreaInsets.bottom
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = BAR_HEIGHT + bottomSafeHeight
        tabFrame.origin.y = self.view.frame.size.height - BAR_HEIGHT - bottomSafeHeight
        self.tabBar.frame = tabFrame
    }

}
