//
//  Cache.swift
//  HomeGenius
//
//  Created by Avismara HL on 19/11/18.
//  Copyright © 2018 Infrrd Technologies Private Limited. All rights reserved.
//

import Foundation
import AppAuth

class CacheImp: Cache {
    
    private let USER_ID = "userId"
    private let AUTH_TOKEN = "authToken"
    private let AUTH_STATE = "authState"
    private let ID_TOKEN = "idToken"
    private let DEVICE_TOKEN = "deviceToken"
    private let DEVICE_IDENTIFIER = "deviceIdentifier"

    var loggedIn: Bool {
        return Authorization.shared.hasValidToken
    }
    
    var userId: String? {
        get {
            return userDefaults.value(forKey: USER_ID) as? String
        }
        set(newValue) {
            save(value: newValue, for: USER_ID)
        }
    }
    
    var authToken: String? {
        get {
            let authToken = userDefaults.value(forKey: AUTH_TOKEN) as? String
            return authToken
        }
        set(newValue) {
            save(value: newValue, for: AUTH_TOKEN)
        }
    }
    
    var authState: OIDAuthState? {
        get {
            if let data = userDefaults.value(forKey: AUTH_STATE) as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? OIDAuthState
            }
            return nil
        }
        set(newValue) {
            guard let value = newValue else {
                save(value: nil, for: AUTH_STATE)
                return 
            }
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            save(value: data, for: AUTH_STATE)
        }
    }
    
    var deviceToken: String? {
        get {
            let deviceToken = userDefaults.value(forKey: DEVICE_TOKEN) as? String
            return deviceToken
        }
        set {
            save(value: newValue, for: DEVICE_TOKEN)
        }
    }
    
    var deviceIdentifier: String? {
        get {
            let deviceIdentifier = userDefaults.value(forKey: DEVICE_IDENTIFIER) as? String
            return deviceIdentifier
        }
        set {
            save(value: newValue, for: DEVICE_IDENTIFIER)
        }
    }
    
    var idToken: String? {
        get {
            let idToken = userDefaults.value(forKey: ID_TOKEN) as? String
            return idToken
        }
        set {
            save(value: newValue, for: ID_TOKEN)
        }
    }
    
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
    var userId: String? { get set }
    var authToken: String? { get set }
    var idToken: String? { get set }
    var loggedIn: Bool { get }
    var authState: OIDAuthState? { get set }
    var deviceToken: String? { get set }
    var deviceIdentifier: String? { get set }
}
