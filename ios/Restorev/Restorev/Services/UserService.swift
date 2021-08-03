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
    func editUserWith(userId: String, name: String, role: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ())
    func getUser(with id: String, success: @escaping (User) -> (), failure: @escaping (ApplicationError) -> ())
    func deleteUserWith(userId: String, success:  @escaping () -> (), failure: @escaping (ApplicationError) -> ())
}

final class UserServiceImp: UserService {
    private let URL = Constants.BASE_URL + "/users"
    private let DATA = "data"
    private let NAME = "name"
    private let ROLE = "role"
    
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
    
    func getUser(with id: String, success: @escaping (User) -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.get(with: URL + "/\(id)", parameters: [String: String](), headers: authTokenHeader()) { [weak self] response in
            guard let self = self else {
                return
            }
            guard let data = response[self.DATA] as? [String: Any] else {
                fatalError("Something is wrong with the API response")
            }
            do {
                let user = try map(json: data, to: User.self)
                success(user)
            } catch {
                fatalError("Something is wrong with the API response")
            }
           
        } failure: { error in
            failure(error)
        }

    }
    
    func editUserWith(userId: String, name: String, role: String, success:  @escaping () -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.put(with: URL + "/\(userId)/edit", parameters: [NAME: name, ROLE: role], headers: authTokenHeader()) { response in
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func deleteUserWith(userId: String, success:  @escaping () -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.delete(with: URL + "/\(userId)/delete", parameters: [String: String](), headers: authTokenHeader()) { response in
            success()
        } failure: { error in
            failure(error)
        }
    }
}
