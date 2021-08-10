//
//  RegisterViewModel.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

protocol RegisterViewModel {
    var didRegister: (() -> ())? { get set }
    var didRegisterFail: ((ApplicationError) -> ())? { get set }
    init()
    init(service: AuthService)
    
    func register(name: String, email: String, password: String, confirmPassword: String)
}

final class RegisterViewModelImp: RegisterViewModel {
    var service: AuthService
    
    var didRegister: (() -> ())?
    var didRegisterFail: ((ApplicationError) -> ())?
    
    init() {
        self.service = AuthServiceImp()
    }
    
    init(service: AuthService) {
        self.service = service
    }
    
    func register(name: String, email: String, password: String, confirmPassword: String) {
        if !validate(name: name, email: email, password: password, confirmPassword: confirmPassword) { return }
        
        self.service.register(name: name, email: email, password: password) { [weak self] in
            self?.didRegister?()
        } failure: { [weak self] error in
            self?.didRegisterFail?(error)
        }
    }
    
    private func validate(name: String, email:String, password: String, confirmPassword: String) -> Bool {
        var validated = true
        
        if password != confirmPassword {
            didRegisterFail?(ValidationError(fieldType: .passwordConfirmPassword))
            validated = false
        }
        
        if confirmPassword.isEmpty {
            didRegisterFail?(ValidationError(fieldType: .confirmPassword))
        }
        
        if name.isEmpty {
            didRegisterFail?(ValidationError(fieldType: .name))
            validated = false
        }
        
        if !email.isValidEmail {
            didRegisterFail?(ValidationError(fieldType: .email))
            validated = false
        }
        
        if password.count < 5 {
            didRegisterFail?(ValidationError(fieldType: .password))
            validated = false
        }
        
        return validated
    }
}
