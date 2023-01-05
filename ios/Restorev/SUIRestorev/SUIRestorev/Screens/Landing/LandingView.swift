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

    var mainBody: some View {
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
                .sheet(isPresented: $isRegistrationShown) {
                    RegistrationView(registerMessage: registerMessage, shouldShow: $isRegistrationShown)
                }
                .sheet(isPresented: $isLoginShown) {

                }
        }
    }

    var body: some View {
        return ZStack {
            if self.registerMessage.isSuccess {
                VStack {
                    ReporterView(type: .success, message: self.registerMessage.promptMesssge, title: self.registerMessage.promptTitle)
                        .frame(height: 75)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    self.registerMessage.isSuccess = false
                                }
                            }
                        }
                    Spacer()
                }
            }
            if self.registerMessage.isFailure {
                VStack {
                    ReporterView(type: .failure, message: self.registerMessage.promptMesssge, title: self.registerMessage.promptTitle)
                        .frame(height: 75)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    self.registerMessage.isFailure = false
                                }
                            }
                        }
                    Spacer()
                }
            }
            mainBody
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
