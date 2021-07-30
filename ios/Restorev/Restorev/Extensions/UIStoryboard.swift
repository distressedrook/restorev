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
}
