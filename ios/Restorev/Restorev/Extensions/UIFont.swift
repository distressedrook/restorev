//
//  UIFont.swift
//  Restorev
//
//  Created by Avismara HL on 31/07/21.
//

import UIKit

extension UIFont {
    static func openSansBold(with size: Int) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: CGFloat(size))!
    }
    
    static func openSansRegular(with size: Int) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: CGFloat(size))!
    }
}
