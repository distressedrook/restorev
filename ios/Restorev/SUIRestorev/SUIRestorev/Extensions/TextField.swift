//
//  TextField.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 04/01/23.
//

import SwiftUI

extension TextField {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
