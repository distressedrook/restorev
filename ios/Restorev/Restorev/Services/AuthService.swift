//
//  AuthServices.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

final class AuthServiceImp: AuthService {
    let REGISTER_URL = Constants.BASE_URL + "/auth/register"
    let LOGIN_URL = Constants.BASE_URL + "/auth/login"
    
    private let NAME = "name"
    private let EMAIL = "email"
    private let PASSWORD = "password"
    private let DATA = "data"
    
    let manager: ServiceManager
    
    init() {
        self.manager = ServiceManagerImp()
    }
    
    init(manager: ServiceManager) {
        self.manager = manager
    }
    
    func register(name: String, email: String, password: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ()) {
        let parameters = [NAME: name, EMAIL: email, PASSWORD: password]
        self.manager.post(with: REGISTER_URL, parameters: parameters, headers: nil) { response in
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func login(email: String, password: String, success: @escaping (User) -> (), failure: @escaping (ApplicationError) -> ()) {
        let parameters = [EMAIL: email, PASSWORD: password]
        self.manager.post(with: LOGIN_URL, parameters: parameters, headers: nil) { [weak self] response in
            guard let self = self, let data = response[self.DATA] as? [String: Any] else {
                fatalError("API is not behaving as expected")
            }
            do {
                success(try map(json: data, to: User.self))
            } catch {
                fatalError("API is not behaving as expected")
            }
        } failure: { error in
            failure(error)
        }
    }
}

protocol AuthService {
    func register(name: String, email: String, password: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ())
    func login(email: String, password: String, success: @escaping (User) -> (), failure: @escaping (ApplicationError) -> ())
}
