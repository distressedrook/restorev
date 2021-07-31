//
//  User.swift
//  Restorev
//
//  Created by Avismara HL on 30/07/21.
//

import UIKit

class User: NSObject, Codable, NSCoding {
    
    private static let ID = "id"
    private static let NAME = "name"
    private static let EMAIL = "email"
    private static let ROLE = "role"
    private static let TOKEN = "token"
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: User.ID)
        coder.encode(self.name, forKey: User.NAME)
        coder.encode(self.email, forKey: User.EMAIL)
        coder.encode(self.role.rawValue, forKey: User.ROLE)
        coder.encode(self.token, forKey: User.TOKEN)
    }
    
    init(id: String, name: String, email: String, role: Role, token: String) {
        self.id = id
        self.name = name
        self.email = email
        self.role = role
        self.token = token
    }
    
    required convenience init(coder: NSCoder) {
        let id = coder.decodeObject(forKey: User.ID) as! String
        let name = coder.decodeObject(forKey: User.NAME) as! String
        let email = coder.decodeObject(forKey: User.EMAIL) as! String
        let role = coder.decodeObject(forKey: User.ROLE) as! String
        let token = coder.decodeObject(forKey: User.TOKEN) as! String
        self.init(id: id, name: name, email: email, role: Role(rawValue: role)!, token: token)
    }
    
    let id: String
    let name: String
    let email: String
    let role: Role
    let token: String
    
}

enum Role: String, Codable {
    case admin = "admin"
    case regular = "regular"
    case owner = "owner"
}
