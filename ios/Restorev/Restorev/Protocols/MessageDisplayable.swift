//
//  MessageDisplayable.swift
//  Restorev
//
//  Created by Avismara HL on 30/07/21.
//

import SwiftMessages
import UIKit

protocol MessageDisplayable {
    func showSuccess(with title: String, message: String)
    func showError(with title: String, message: String)
}

extension MessageDisplayable {
    func showSuccess(with title: String, message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.button?.isHidden = true
        view.iconLabel?.isHidden = true
        view.configureDropShadow()
        view.configureContent(title: title, body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        SwiftMessages.show(view: view)
    }
    
    func showError(with title: String, message: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.error)
        view.button?.isHidden = true
        view.configureDropShadow()
        view.iconLabel?.isHidden = true
        view.configureContent(title: title, body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 24, left: 8, bottom: 24, right: 8)
        SwiftMessages.show(view: view)
    }
}
