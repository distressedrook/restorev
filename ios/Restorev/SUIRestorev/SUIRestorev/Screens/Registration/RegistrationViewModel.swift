//
//  RegistrationViewModel.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 04/01/23.
//

import SwiftUI


class RegistrationViewModel: ObservableObject {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    @Binding var showShow: Bool
    @ObservedObject var registerMessage: RegisterMessage

    private let authService: AuthService

    init(registerMessage: RegisterMessage, shouldShow: Binding<Bool>, authService: AuthService = AuthServiceImp()) {
        _showShow = Binding(projectedValue: shouldShow)
        self.registerMessage = registerMessage
        self.authService = authService
    }

    func submit() {
        Task {
            do {
                try await self.authService.register(name: self.name, email: self.email, password: self.password)
                self.registerMessage.promptTitle = Strings.success
                self.registerMessage.promptMesssge = Strings.accountCreated
                self.registerMessage.isSuccess = true
            } catch {
                self.registerMessage.promptTitle = Strings.failure
                guard let error = error as? ApplicationError else {
                    self.registerMessage.promptMesssge = Strings.oops
                    return
                }
                self.registerMessage.promptMesssge = error.displayString
                self.registerMessage.isFailure = true
            }
            self.showShow = false
        }
    }
}
