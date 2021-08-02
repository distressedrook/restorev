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
}
