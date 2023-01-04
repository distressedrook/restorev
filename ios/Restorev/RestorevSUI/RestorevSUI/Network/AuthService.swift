
//
//  AuthServices.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

let BASE_URL = "http://127.0.0.1:3001"

struct AuthServiceImp: AuthService {
    let REGISTER_URL = BASE_URL + "/auth/register"
    let LOGIN_URL = BASE_URL + "/auth/login"

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

    func register(name: String, email: String, password: String) async throws {
        let parameters = [NAME: name, EMAIL: email, PASSWORD: password]
        try await self.manager.post(with: REGISTER_URL, parameters: parameters, headers: nil)
    }

    func login(email: String, password: String) async throws -> User {
        let parameters = [EMAIL: email, PASSWORD: password]
        let result = try await self.manager.post(with: LOGIN_URL, parameters: parameters, headers: nil)
        guard let data = result[self.DATA] as? [String: Any] else {
            fatalError("API is not behaving as expected")
        }
        do {
            return try map(json: data, to: User.self)
        } catch {
            fatalError("API is not behaving as expected")
        }
    }
}

protocol AuthService {
    func register(name: String, email: String, password: String) async throws
    func login(email: String, password: String) async throws -> User
}
