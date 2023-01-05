//
//  RegisterMessage.swift
//  SUIRestorev
//
//  Created by Avismara Hugoppalu on 05/01/23.
//

import Foundation

class RegisterMessage: ObservableObject {
    @Published var isSuccess: Bool = false
    @Published var isFailure: Bool = false
    @Published var promptTitle: String = ""
    @Published var promptMesssge: String = ""
}
