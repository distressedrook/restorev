//
//  ApplicationError.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

class ApplicationError: Error {
    var displayString: String {
        return errorDisplayMap[self.code] ?? Strings.oops
    }
    var code: ErrorCode
    init(code: ErrorCode) {
        self.code = code
    }
}
