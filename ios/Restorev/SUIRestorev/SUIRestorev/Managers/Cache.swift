//
//  Cache.swift
//  RestorevSUI
//
//  Created by Avismara Hugoppalu on 03/01/23.
//

import Foundation

class Cache {

    static var shared = Cache()

    @Cachable(key: "user")
    var user: User?

    init() {}

}

