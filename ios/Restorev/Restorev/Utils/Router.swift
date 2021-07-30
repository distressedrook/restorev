//
//  Router.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

protocol Router: AnyObject {
    init(navigatable: Navigatable)
    var navigatable: Navigatable? { get set }
    func dismiss(completion: (() -> Void)?)
}

extension Router {
    func dismiss(completion: (() -> Void)? = nil) {
        self.navigatable?.dismiss(animated: true, completion: completion)
    }
}
