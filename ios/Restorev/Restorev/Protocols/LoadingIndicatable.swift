//
//  LoadingIndicatable.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import UIKit
import NVActivityIndicatorView

private let LOADING_VIEW_TAG = 12446
private let INDICATOR_VIEW_TAG = 12447

protocol LoadingIndicatable where Self: UIViewController {
}

extension LoadingIndicatable {
    func showLoading(layerColor: UIColor = .white.withAlphaComponent(0.6), origin: CGPoint? = nil) {
        if let view = self.view.viewWithTag(LOADING_VIEW_TAG), view.viewWithTag(INDICATOR_VIEW_TAG) != nil {
            return
        }
        let view = UIView(frame: self.view.bounds)
        if let safeOrigin = origin {
            view.frame.origin = safeOrigin
        }
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 44, height: 44), type: .ballBeat, color: .brandBlue, padding: 0)
        let indicatorViewX = (view.frame.size.width - 44) / 2
        let indicatorViewY = (view.frame.size.height - 44) / 2
        indicatorView.frame = CGRect(x: indicatorViewX, y: indicatorViewY, width: 44, height: 44)
        indicatorView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        indicatorView.tag = INDICATOR_VIEW_TAG
        indicatorView.startAnimating()
        view.tag = LOADING_VIEW_TAG
        self.setup(overlayView: view, layerColor: layerColor)
        view.addSubview(indicatorView)
        self.view.addSubview(view)
    }
    
    private func setup(overlayView: UIView, layerColor: UIColor) {
        overlayView.tag = LOADING_VIEW_TAG
        overlayView.backgroundColor = layerColor
        overlayView.isUserInteractionEnabled = true
    }
    
    func hideLoading() {
        guard let view = self.view.viewWithTag(LOADING_VIEW_TAG) else {
            return
        }
        let indicator = self.view.viewWithTag(INDICATOR_VIEW_TAG) as? NVActivityIndicatorView
        indicator?.stopAnimating()
        indicator?.isHidden = true
        view.removeFromSuperview()
    }
}
