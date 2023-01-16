//
//  RegistrationView.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 04/01/23.
//

import SwiftUI

struct RegistrationView: View {

    @State private var name: String
    @State private var email: String
    @State private var password: String
    @State private var confirmPassword: String

    @State private var shouldShakeNameField = false
    @State private var shouldShakeEmailField = false
    @State private var shouldShakePasswordField = false
    @State private var shouldshakeCPasswordfield = false

    @Binding var shouldShow: Bool
    @State private var shouldShowLoading = false
    @ObservedObject var parentRegisterMessage: RegisterMessage
    @StateObject var registerMessage: RegisterMessage = RegisterMessage()

    private let authService: AuthService
    private let shakeAnimation = Animation.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true)

    init(registerMessage: RegisterMessage, shouldShow: Binding<Bool>, authService: AuthService = AuthServiceImp(), name: String = "", email: String = "", password: String = "", confirmPassword: String = "") {
        _parentRegisterMessage = ObservedObject(wrappedValue: registerMessage)
        _shouldShow = shouldShow
        self.authService = authService

        _name = State(wrappedValue: name)
        _email = State(wrappedValue: email)
        _password = State(wrappedValue: password)
        _confirmPassword = State(wrappedValue: confirmPassword)

    }


    var body: some View {
        VStack {
            Text(Strings.register)
                .font(.banner)
                .foregroundColor(.brand)

            TextField(Strings.name, text: $name)
                .formStyled
                .animation(Animation.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true), value: shouldShakeNameField)
                .offset(x: shouldShakeNameField ? 10 : 0)
            TextField(Strings.email, text: $email)
                .formStyled
                .animation(Animation.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true), value: shouldShakeEmailField)
                .offset(x: shouldShakeEmailField ? 10 : 0)
                .keyboardType(.emailAddress)
            SecureField(Strings.password, text: $password)
                .formStyled
                .animation(Animation.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true), value: shouldShakePasswordField)
                .offset(x: shouldShakePasswordField ? 10 : 0)
            SecureField(Strings.confirmPassword, text: $confirmPassword)
                .formStyled
                .animation(Animation.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true), value: shouldshakeCPasswordfield)
                .offset(x: shouldshakeCPasswordfield ? 10 : 0)
                .padding(.bottom, 44)
            Button(action: onSubmit) {
                Text(Strings.register)
                    .frame(width: 165, height: 70)
                    .background(Color.brand)
                    .foregroundColor(.onBrand)
                    .font(.largeButton)
            }
            .padding([.bottom,.leading,.trailing], 16)
        }
        .showMessage(registerMessage: ObservedObject(wrappedValue: registerMessage), shouldShow: $registerMessage.isFailure) {

        }
        .showLoading(shouldShow: $shouldShowLoading)
    }

    private func validate() -> Bool {
        var isValid = true
        if name.isEmpty {
            shouldShakeNameField = true
            isValid = false
        }

        if email.isEmpty {
            shouldShakeEmailField = true
            isValid = false
        }

        if confirmPassword.isEmpty {
            shouldshakeCPasswordfield = true
            isValid = false
        }

        if password.isEmpty {
            shouldShakePasswordField = true
            isValid = false
        }

        if !email.isValidEmail && !email.isEmpty {
            shouldShakeEmailField = true
            registerMessage.isFailure = true
            registerMessage.promptTitle = Strings.failure
            registerMessage.promptMesssge = Strings.invalidEmail
            isValid = false
        } else if confirmPassword != password && !password.isEmpty {
            shouldShakePasswordField = true
            shouldshakeCPasswordfield = true
            registerMessage.isFailure = true
            registerMessage.promptTitle = Strings.success
            registerMessage.promptMesssge = Strings.passwordMismatch
            isValid = false
        } else if password.count < 5 && !password.isEmpty {
            shouldShakePasswordField = true
            registerMessage.isFailure = true
            registerMessage.promptTitle = Strings.failure
            registerMessage.promptMesssge = Strings.passwordLengthError
            isValid = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            shouldShakeNameField = false
            shouldShakeEmailField = false
            shouldshakeCPasswordfield = false
            shouldShakePasswordField = false
        }
        return isValid

    }

    func onSubmit() {
        if !validate() { return }
        withAnimation { shouldShowLoading = true }
        Task {
            do {
                try await self.authService.register(name: self.name, email: self.email, password: self.password)
                self.parentRegisterMessage.promptTitle = Strings.success
                self.parentRegisterMessage.promptMesssge = Strings.accountCreated
                self.parentRegisterMessage.isSuccess = true
                self.shouldShow = false
            } catch {
                self.registerMessage.promptTitle = Strings.failure
                guard let error = error as? ApplicationError else {
                    self.registerMessage.promptMesssge = Strings.oops
                    return
                }
                self.registerMessage.promptMesssge = error.displayString
                withAnimation {
                    self.shouldShowLoading = false
                    self.registerMessage.isFailure = true
                }

            }

        }
    }

}


private extension View {
    var formStyled: some View {
        self.frame(height: 60)
            .padding([.leading, .trailing], 16)
            .background(Color.elementBackground)
            .padding([.leading, .trailing], 44)
            .font(.largeTextField)
    }
}


