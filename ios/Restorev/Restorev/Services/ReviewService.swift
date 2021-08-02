//
//  ReviewService.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//
import Foundation

protocol ReviewService {
    init()
    init(serviceManager: ServiceManager)
    func commentToReviewWith(reviewId: String, comment:String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ())
    func getPendingReviews(success: @escaping ([PendingRestaurants]) -> (), failure: @escaping (ApplicationError) -> ())
}

final class ReviewServiceImp: ReviewService {
    private let URL = Constants.BASE_URL + "/reviews"
    private let DATA = "data"
    private let COMMENT = "comment"
    let serviceManager: ServiceManager
    
    init() {
        self.serviceManager = ServiceManagerImp()
    }
    
    init(serviceManager: ServiceManager) {
        self.serviceManager = serviceManager
    }
    
    func commentToReviewWith(reviewId: String, comment:String, success: @escaping () -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.post(with: URL + "/\(reviewId)/comment", parameters: [COMMENT: comment], headers: authTokenHeader()) { response in
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func getPendingReviews(success: @escaping ([PendingRestaurants]) -> (), failure: @escaping (ApplicationError) -> ()) {
        self.serviceManager.get(with: URL + "/pending", parameters: [String: String](), headers: authTokenHeader()) { [weak self] response in
            guard let self = self else {
                return
            }
            guard let data = response[self.DATA] as? [Any] else {
                fatalError("Something is wrong with the API")
            }
            do {
                success(try parse(with: data, to: PendingRestaurants.self))
            } catch {
                fatalError("Something is wrong with the API")
            }
        } failure: { error in
            failure(error)
        }
    }
    
}
