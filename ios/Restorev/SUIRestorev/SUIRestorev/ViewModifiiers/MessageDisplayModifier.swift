//
//  MessagesModifier.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 06/01/23.
//

import SwiftUI

struct MessageDisplayModifier: ViewModifier {
    @Binding var shouldShow: Bool
    @ObservedObject var registerMessage: RegisterMessage
    var done: () -> ()

    init(registerMessage: ObservedObject<RegisterMessage>, shouldShow: Binding<Bool>, done: @escaping () -> ()) {
        _shouldShow = shouldShow
        _registerMessage = registerMessage
        self.done = done
    }

    func body(content: Content) -> some View {
        return ZStack {
            if shouldShow {
                VStack {
                    ReporterView(type: registerMessage.isFailure ? .failure : .success, message: registerMessage.promptMesssge, title: registerMessage.promptTitle)
                        .frame(height: 100)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    self.shouldShow = false
                                }
                            }
                        }
                    Spacer()
                }
            }
            content
        }
    }
}

extension View {
    func showMessage(registerMessage: ObservedObject<RegisterMessage>, shouldShow: Binding<Bool>, done: @escaping () -> ()) -> some View {
        return modifier(MessageDisplayModifier(registerMessage: registerMessage, shouldShow: shouldShow, done: done))
    }
}
