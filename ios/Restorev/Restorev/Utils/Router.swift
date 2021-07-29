//
//  Router.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit

protocol Router: AnyObject {
    var viewController: UIViewController? { get set }
    func dismiss(completion: (() -> Void)?)
}

extension Router {
    func dismiss(completion: (() -> Void)? = nil) {
        self.viewController?.dismiss(animated: true, completion: completion)
    }
}
