//
//  LoginView.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 06/01/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String
    @State private var password: String

    @State private var shouldShakeEmailField = false
    @State private var shouldShakePasswordField = false

    @State private var shouldShowLoading = false

    @Binding var shouldShow: Bool
    @StateObject var registerMessage: RegisterMessage = RegisterMessage()

    private let authService: AuthService

    init(shouldShow: Binding<Bool>, authService: AuthService = AuthServiceImp(), email: String = "", password: String = "") {
        _shouldShow = shouldShow
        self.authService = authService

        _email = State(wrappedValue: email)
        _password = State(wrappedValue: password)

    }


    var body: some View {
        VStack {
            Text(Strings.login)
                .font(.banner)
                .foregroundColor(.brand)
            TextField(Strings.email, text: $email)
                .formStyled
                .animation(Animation.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true), value: shouldShakeEmailField)
                .offset(x: shouldShakeEmailField ? 10 : 0)
                .keyboardType(.emailAddress)
            SecureField(Strings.password, text: $password)
                .formStyled
                .animation(Animation.easeInOut(duration: 0.05).repeatCount(10, autoreverses: true), value: shouldShakePasswordField)
                .offset(x: shouldShakePasswordField ? 10 : 0)
                .padding(.bottom, 44)
            Button(action: onLogin) {
                Text(Strings.login)
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

        if email.isEmpty {
            shouldShakeEmailField = true
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
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            shouldShakeEmailField = false
            shouldShakePasswordField = false
        }
        return isValid

    }

    func onLogin() {
        if !validate() { return }
        withAnimation { shouldShowLoading = true }
        Task {
            do {
                let user = try await self.authService.login(email: email, password: password)
                Cache.shared.user = user
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


