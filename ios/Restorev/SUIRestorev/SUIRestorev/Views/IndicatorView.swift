//
//  IndicatorView.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 06/01/23.
//

import Foundation
import SwiftUI
import UIKit
import NVActivityIndicatorView

struct IndicatorView: UIViewRepresentable {
    func makeUIView(context: Context) -> NVActivityIndicatorView {
        let indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 44, height: 44), type: .ballBeat, color: UIColor(Color.brand), padding: 0)
        indicatorView.startAnimating()
        return indicatorView
    }

    func updateUIView(_ uiView: NVActivityIndicatorView, context: Context) {

    }

    typealias UIViewType = NVActivityIndicatorView


}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView().frame(width: 44, height: 44)

    }
}
