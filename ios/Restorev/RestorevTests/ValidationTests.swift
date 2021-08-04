//
//  ValidationTests.swift
//  RestorevTests
//
//  Created by Avismara Hugoppalu on 04/08/21.
//

import XCTest
import Restorev

class ValidationTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInvalidEmail() {
        let viewModelImp = LoginViewModelImp()
        let promise = expectation(description: "Validation Expectation")
        viewModelImp.didRegisterFail = { error in
            if let error = error as? ValidationError {
                if error.type == .email {
                    print("Asserting true")
                    promise.fulfill()
                }
            }
        }
        viewModelImp.login(email: "", password: "password")
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testInvalidPassword() {
        let viewModelImp = LoginViewModelImp()
        let promise = expectation(description: "Validation Expectation")
        viewModelImp.didRegisterFail = { error in
            if let error = error as? ValidationError {
                if error.type == .password {
                    promise.fulfill()
                }
            }
        }
        viewModelImp.login(email: "avismarahl@gmail.com", password: "pass")
        waitForExpectations(timeout: 1, handler: nil)
    }



}
