//
//  UserService.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import Foundation

protocol UserService {
    init()
    init(serviceManager: ServiceManager)
    func getAllUsers(success: @escaping ([User]) -> (), failure: @escaping (ApplicationError) -> ())
}

final class UserServiceImp: UserService {
    private let URL = Constants.BASE_URL + "/users"
    private let DATA = "data"
    
    let serviceManager: ServiceManager
    
    init() {
        self.serviceManager = ServiceManagerImp()
    }
    
    init(serviceManager: ServiceManager) {
        self.serviceManager = serviceManager
    }
    
    func getAllUsers(success: @escaping ([User]) -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.get(with: URL, parameters: [String: String](), headers: authTokenHeader()) { [weak self] response in
            guard let self = self else {
                return
            }
            guard let usersJSON = response[self.DATA] as? [Any] else {
                fatalError("Something is wrong with the response")
            }
            do {
                let users = try parse(with: usersJSON, to: User.self)
                success(users)
            } catch {
                fatalError("Something is wrong with the API response")
            }
            
        } failure: { error in
            failure(error)
        }
    }
}
