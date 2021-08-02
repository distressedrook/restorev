//
//  SettingsViewController.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

class SettingsViewController: UIViewController {
    var router: SettingsRouter!
    var cache: Cache!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapSignoutButton(sender: UIButton) {
        cache.user = nil
        let delegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        delegate.window?.rootViewController = UIViewController.landing
    }
}
