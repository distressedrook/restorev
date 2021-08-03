//
//  UsersViewModel.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import Foundation

protocol UsersViewModel {
    func getUsers()
    
    var didGetUsers: (() -> ())? { get set }
    var didGetUsersFail: ((ApplicationError) -> ())? { get set }
    
    var numberOfUsers: Int { get }
    func userName(at index: Int) -> String
    func userId(at index: Int) -> String
}

class UsersViewModelImp: UsersViewModel {
    
    let service: UserService
    var users: [User]!
    
    var numberOfUsers: Int {
        return self.users?.count ?? 0
    }
    
    func userName(at index: Int) -> String {
        return self.users[index].name
    }
    
    func userId(at index: Int) -> String {
        return self.users[index].id
    }
    
    init() {
        self.service = UserServiceImp()
    }
    
    init(service: UserService) {
        self.service = service
    }

    func getUsers() {
        self.service.getAllUsers { users in
            self.users = users
            self.didGetUsers?()
        } failure: { error in
            self.didGetUsersFail?(error)
        }
    }
    
    var didGetUsers: (() -> ())?
    var didGetUsersFail: ((ApplicationError) -> ())?
}
