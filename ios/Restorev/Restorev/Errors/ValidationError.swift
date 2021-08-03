//
//  ValidationError.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Foundation

class ValidationError: ApplicationError {
    let type: FieldType
    
    enum FieldType {
        case name, password, email, date, review, rating, role
    }
    
    init(fieldType: FieldType) {
        self.type = fieldType
        super.init(code: .validation)
    }
}
