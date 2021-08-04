//
//  HomeTabBarViewController.swift
//  Restorev
//
//  Created by Avismara HL on 30/07/21.
//

import UIKit

class HomeTabBarController: UITabBarController, MessageDisplayable {
    private let BAR_HEIGHT: CGFloat = 70
    var cache: Cache = CacheImp()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showSuccess(with:  Strings.loggedIn + "\(cache.user!.name)", message: "")
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
