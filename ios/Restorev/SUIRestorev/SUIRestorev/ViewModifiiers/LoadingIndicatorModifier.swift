//
//  LoadingIndicatorModifier.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 06/01/23.
//

import SwiftUI

struct LoadingIndicatorModifier: ViewModifier {

    @Binding var shouldShow: Bool

    init(shouldShow: Binding<Bool>) {
        _shouldShow = shouldShow
    }

    func body(content: Content) -> some View {
        return ZStack {
            content
            if shouldShow {
                GeometryReader { reader in
                    VStack {
                        IndicatorView().frame(width: 44, height: 44)
                    }
                    .frame(width: reader.size.width, height: reader.size.height)
                    .background(Color(UIColor.white.withAlphaComponent(0.6)))
                }
            }
        }
    }
}

extension View {
    func showLoading(shouldShow: Binding<Bool>) -> some View {
        return self.modifier(LoadingIndicatorModifier(shouldShow: shouldShow))
    }
}
