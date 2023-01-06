//
//  Landing.swift
//  RestorevSUI
//
//  Created by Avismara Hugoppalu on 04/01/23.
//

import SwiftUI

struct LandingView: View {

    @State var isRegistrationShown = false
    @State var isLoginShown = false

    @StateObject var registerMessage = RegisterMessage()

    var body: some View {
        VStack {
            Image.logoLarge
                .resizable()
                .frame(width: 240, height: 128)
                .padding(.bottom, 0)
            Text(Strings.bannerTitle)
                .font(.banner)
                .foregroundColor(.brand)
                .padding(.bottom, 44)
            Button(Strings.register, action: onRegister)
                .frame(width: 165, height: 70)
                .background(Color.brand)
                .foregroundColor(.onBrand)
                .font(.largeButton)
                .padding([.bottom,.leading,.trailing], 16)
            Button(Strings.login, action: onLogin)
                .frame(width: 165, height: 70)
                .foregroundColor(.brand)
                .font(.largeButton)
                .border(Color.brand)
        }
        .sheet(isPresented: $isRegistrationShown) {
            RegistrationView(registerMessage: registerMessage, shouldShow: $isRegistrationShown)
        }
        .sheet(isPresented: $isLoginShown) {
            LoginView(shouldShow: $isLoginShown)
        }
        .showMessage(registerMessage: ObservedObject(wrappedValue: registerMessage), shouldShow: $registerMessage.isSuccess) {

        }
        .showMessage(registerMessage: ObservedObject(wrappedValue: registerMessage), shouldShow: $registerMessage.isFailure) {

        }
    }

    private func onRegister() {
        isRegistrationShown = true
    }

    private func onLogin() {
        isLoginShown = true
    }

}


struct Landing_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}

