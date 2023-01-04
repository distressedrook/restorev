//
//  Cache.swift
//  RestorevSUI
//
//  Created by Avismara Hugoppalu on 03/01/23.
//

import Foundation

class CacheImp: Cache {
    @Cachable(key: "user")
    var user: User?
}

protocol Cache {
    var user: User? { get set }
}

