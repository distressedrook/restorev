//
//  EditReviewTests.swift
//  RestorevTests
//
//  Created by Avismara Hugoppalu on 05/08/21.
//

import XCTest

fileprivate let reviewer = User(id: "1", name: "Test User", email: "test@gmail.com", role: .regular, token: "112341234")
fileprivate let trReview = Review(restaurantId: "1234", visitedDate: 12341234, rating: 3, ownerComment: "Nice", id: "6778", review: "Nice", reviewer: reviewer)
fileprivate let mcReview = Review(restaurantId: "1234", visitedDate: 12341234, rating: 3, ownerComment: "Nice", id: "6778", review: "Nice", reviewer: reviewer)
fileprivate let review = Review(restaurantId: "1234", visitedDate: 12341234, rating: 3, ownerComment: "Nice", id: "6778", review: "Nice", reviewer: reviewer)

class EditReviewTests: XCTestCase {
    private let IMMEDIATE = 0.1
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMoveToComment() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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


class MockRouter: RestaurantDetailRouter {
    
    var didCallMoveToComment: ((Review) -> ())?
    
    required init(navigatable: Navigatable) {
        
    }
    var navigatable: Navigatable?
    
    func dismiss(completion: (() -> Void)?) {
        
    }
    
    func moveToReview(restaurantName: String, restaurantId: String, delegate: ReviewViewControllerDelegate?) {
        
    }
    func moveToComment(review: Review, delegate: CommentViewControllerDelegate?) {
        self.didCallMoveToComment?(review)
    }
    func moveToEditWith(restaurantId: String, restaurantName: String, delegate: AddRestaurantViewControllerDelegate) {
        
    }
    func moveToEditReviewWith(restaurantId: String, restaurantName: String, review: Review, delegate: ReviewViewControllerDelegate) {
        
    }
    func moveToEditCommentWith(review: Review, delegate: CommentViewControllerDelegate) {
        
    }
    func pop() {
        
    }
}


class MockViewModel: RestaurantDetailViewModel {
    var didGetRestaurantDetail: (() -> ())?
    var didGetRestaurantDetailFail: ((ApplicationError) -> ())?
    
    var restaurantName: String = "Test"
    var restaurantId: String = "12345"
    
    var averageRating: Double = 5
    var numberOfReviews: Int  = 1
    
    var topRatedReview: Review! = trReview
    var mostCriticalReview: Review! = mcReview
    
    var topRatedReviewString: String = "Nice"
    var topRatedReviewId: String = "6778"
    var topReviewerName: String = "Test User"
    var topRatedRating: Int = 3
    var topRatedVisiteDate: Int = 12341234
    var topRatedOwnerComment: String? = "Nice"
    
    var mostCriticalReviewString: String = "Nice"
    var mostCriticalReviewId: String = "6778"
    var mostCriticalReviewerName: String = "Test User"
    var mostCriticalRating: Int = 3
    var mostCriticalVisiteDate: Int = 12341234
    var mostCriticalOwnerComment: String? = "Nice"
    
    func ratingAt(index: Int) -> Int {
        return 3
    }
    
    func reviewIdAt(index: Int) -> String {
        return "6778"
    }
    
    func reviewerNameAt(index: Int) -> String {
        return "Test User"
    }
    
    func visitedDateAt(index: Int) -> Int {
        return 12341234
    }
    
    func reviewAt(index: Int) -> String {
        return "Nice"
    }
    
    func commentAt(index: Int) -> String? {
        return "Nice"
    }
    
    func mReview(at index: Int) -> Review {
        return review
    }
    
    func getDetail() {
        
    }
}
