//
//  Cache.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

class CacheImp: Cache {
    var user: User? {
        get {
            guard let useData = self.userDefaults.value(forKey: USER) as? Data else {
                return nil
            }
            let user = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(useData) as? User
            return user
        }
        set(newValue) {
            guard let newValue = newValue else {
                fatalError("You cannot set a nil value to user")
            }
            let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
            self.save(value: encodedData, for: USER)
        }
    }
    
    private let USER = "user"
    private let userDefaults = UserDefaults.standard
    
    private func save(value: Any?, for key: String) {
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }
    
    private func save(bool: Bool, for key: String) {
        userDefaults.set(bool, forKey: key)
        userDefaults.synchronize()
    }
}

protocol Cache {
    var user: User? { get set }
}
