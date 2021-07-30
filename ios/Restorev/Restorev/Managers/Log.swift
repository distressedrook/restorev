//
//  Log.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

struct Log {
    static var enabled = true
    
    static func d(_ message: Any) {
        if enabled {
            print(message)
        }
    }
    static func v(_ message: Any) {
        if enabled {
            print(message)
        }
        
    }
    static func e(_ message: Any) {
        if enabled {
            print(message)
        }
    }
    static func i(_ message: Any) {
        if enabled {
            print(message)
        }
        
    }
    static func w(_ message: Any) {
        if enabled {
            print(message)
        }
        
    }
}
