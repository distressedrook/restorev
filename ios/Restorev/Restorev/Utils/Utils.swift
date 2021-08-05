//
//  Utils.swift
//  Restorev
//
//  Created by Avismara HL on 30/07/21.
//

import Foundation

let AUTHORIZATION = "Authorization"

func authTokenHeader(cache: Cache = CacheImp()) -> [String: String] {
    let AUTHORIZATION = "Authorization"
    guard cache.user?.token != nil else {
        return [String: String]()
    }
    return [AUTHORIZATION: bearerString(cache: cache)]
}

func bearerString(cache: Cache = CacheImp()) -> String {
    guard let authToken = cache.user?.token else {
        return ""
    }
    return "Bearer " + authToken
}

func map<T: Decodable>(json: Any, to type: T.Type) throws -> T {
    let parseData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    let mappedObject = try JSONDecoder().decode(T.self, from: parseData)
    return mappedObject
}

func parse<T: Decodable>(with jsons: [Any], to type: T.Type) throws -> [T] {
    var objects = [T]()
    for json in jsons {
        let object = try map(json: json, to: T.self)
        objects.append(object)
    }
    return objects
}

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

enum Notifications: String, NotificationName {
    case forbidden
}
