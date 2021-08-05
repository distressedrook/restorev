//
//  ValidationTests.swift
//  RestorevTests
//
//  Created by Avismara Hugoppalu on 04/08/21.
//

import XCTest
import Restorev

class ValidationTests: XCTestCase {
    private let IMMEDIATE = 1.0
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
        waitForExpectations(timeout: IMMEDIATE, handler: nil)
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
        waitForExpectations(timeout: IMMEDIATE, handler: nil)
    }

    func testValidInput() {
        let promise = expectation(description: "Valiation Expectation")
        class MockAuthService: AuthService {
            var fulfill: (() -> ())?
            func register(name: String, email: String, password: String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ()) {
                
            }
            
            func login(email: String, password: String, success: @escaping (User) -> (), failure: @escaping (ApplicationError) -> ()) {
                fulfill?()
            }
        }
        let service = MockAuthService()
        service.fulfill = {
            promise.fulfill()
        }
        let viewModel = LoginViewModelImp(service: service, cache: CacheImp())
        viewModel.login(email: "correct@gmail.com", password: "password")
        waitForExpectations(timeout: IMMEDIATE, handler: nil)
    }
}
