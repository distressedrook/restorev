//
//  RegistrationView.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 04/01/23.
//

import SwiftUI

struct RegistrationView: View {

    init(registerMessage: RegisterMessage, shouldShow: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: RegistrationViewModel(registerMessage: registerMessage, shouldShow: shouldShow))

    }

    @StateObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack {
            Text(Strings.register)
                .font(.banner)
                .foregroundColor(.brand)
            TextField(Strings.name, text: $viewModel.name)
                .formStyled
            TextField(Strings.email, text: $viewModel.email)
                .formStyled
                .keyboardType(.emailAddress)
            SecureField(Strings.password, text: $viewModel.password)
                .formStyled
            SecureField(Strings.confirmPassword, text: $viewModel.confirmPassword)
                .formStyled
                .padding(.bottom, 44)
            Button(Strings.register, action: onSubmit)
                .frame(width: 165, height: 70)
                .background(Color.brand)
                .foregroundColor(.onBrand)
                .font(.largeButton)
                .padding([.bottom,.leading,.trailing], 16)
        }
    }


    private func onSubmit() {
        viewModel.submit()
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
