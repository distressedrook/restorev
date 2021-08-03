//
//  EditUserViewModel.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import Foundation

protocol EditUserViewModel {
    
    var userName: String { get }
    var role: String { get }
    
    var didEditUser: (() -> ())? { get set }
    var didEditUserFail: ((ApplicationError) -> ())? { get set }
    
    var didGetUser: (() -> ())? { get set }
    var didGetUserFail: ((ApplicationError) -> ())? { get set  }
    
    var didDeleteUser: (() -> ())? { get set }
    var didDeleteUserFail: ((ApplicationError) -> ())? { get set }
    
    func editUser(name: String, role: String)
    func deleteUser()
    func getUser()
}

class EditUserViewModelImp: EditUserViewModel {
    let service: UserService
    let userId: String
    var user: User!
    
    init(userId: String) {
        self.service = UserServiceImp()
        self.userId = userId
    }
    
    init(service: UserService, userId: String) {
        self.service = service
        self.userId = userId
    }
    
    var didEditUser: (() -> ())?
    var didEditUserFail: ((ApplicationError) -> ())?
    
    var didGetUser: (() -> ())?
    var didGetUserFail: ((ApplicationError) -> ())?
    var didDeleteUser: (() -> ())?
    var didDeleteUserFail: ((ApplicationError) -> ())?
    
    var userName: String {
        return self.user.name
    }
    
    var role: String {
        return self.user.role!.rawValue
    }
    
    func getUser() {
        self.service.getUser(with: self.userId) { user in
            self.user = user
            self.didGetUser?()
        } failure: { error in
            self.didGetUserFail?(error)
        }
    }
    
    func editUser(name: String, role: String) {
        if name.isEmpty {
            self.didEditUserFail?(ValidationError(fieldType: .name))
            return
        } else if role.isEmpty {
            self.didEditUserFail?(ValidationError(fieldType: .role))
            return
        }
        self.service.editUserWith(userId: self.userId, name: name, role: role) {
            self.didEditUser?()
        } failure: { error in
            self.didEditUserFail?(error)
        }

    }
    
    func deleteUser() {
        self.service.deleteUserWith(userId: userId) {
            self.didDeleteUser?()
        } failure: { error in
            self.didDeleteUserFail?(error)
        }
    }
}
