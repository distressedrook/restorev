//
//  ViewControllerNavigating.swift
//  Restorev
//
//  Created by Avismara on 29/07/21
//

import Foundation
import UIKit

protocol Navigatable: AnyObject {
    var navigationController: UINavigationController? { get }
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    func performSegue(withIdentifier identifier: String, sender: Any?)
}

extension UIViewController: Navigatable { }
