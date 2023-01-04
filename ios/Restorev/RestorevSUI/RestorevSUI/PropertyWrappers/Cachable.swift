//
//  Cachable.swift
//  RestorevSUI
//
//  Created by Avismara Hugoppalu on 03/01/23.
//

import Foundation

@propertyWrapper
struct Cachable<Value> {
    var wrappedValue: Value? {
        get {
            guard let data = self.userDefaults.value(forKey: self.key) as? Data else { return nil }
            return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Value
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
            userDefaults.synchronize()
        }
    }
    let key: String
    let userDefaults = UserDefaults.standard
}
