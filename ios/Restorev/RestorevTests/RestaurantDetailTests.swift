//
//  EditReviewTests.swift
//  RestorevTests
//
//  Created by Avismara Hugoppalu on 05/08/21.
//

import XCTest

class RestaurantDetailTests: XCTestCase {
    private let IMMEDIATE = 0.1
    override func setUpWithError() throws { }
    
    override func tearDownWithError() throws {}
    
    func testMoveToComment() throws {
        let promise = expectation(description: "Validation Expectation")
        let viewController = RestaurantDetailViewController()
        let router = MockRouter(navigatable: viewController)
        router.didCallMoveToComment = { review in
            if review.id == "6778" {
                promise.fulfill()
            }
        }
        viewController.router = router
        viewController.viewModel = MockViewModel()
        viewController.moveToCommentIn(section: 2, row: 0)
        waitForExpectations(timeout: IMMEDIATE, handler: nil)
    }
}


