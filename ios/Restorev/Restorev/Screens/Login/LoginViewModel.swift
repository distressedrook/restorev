//
//  RegisterViewModel.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

protocol LoginViewModel {
    init()
    init(service: AuthService, cache: Cache)
    
    var didRegisterFail: ((ApplicationError) -> ())? { get set }
    var didRegisterSuccess: ((User) -> ())? { get set }
    
    func login(email: String, password: String)
}

final class LoginViewModelImp: LoginViewModel {
    let service: AuthService
    var cache: Cache
    
    var didRegisterFail: ((ApplicationError) -> ())?
    var didRegisterSuccess: ((User) -> ())?
    
    init() {
        self.service = AuthServiceImp()
        self.cache = CacheImp()
    }
    
    init(service: AuthService, cache: Cache) {
        self.service = service
        self.cache = cache
    }
    
    private func validate(email:String, password: String) -> Bool {
        var validated = true
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
    
    func login(email: String, password: String) {
        if !validate(email: email, password: password) { return }
        self.service.login(email: email, password: password) { [weak self] user in
            self?.cache.user = user
            self?.didRegisterSuccess?(user)
        } failure: { [weak self] error in
            self?.didRegisterFail?(error)
        }
    }
}
