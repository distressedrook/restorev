//
//  ServiceManager.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//

import Alamofire
import Foundation

class ServiceManagerImp: ServiceManager {
    
    let SUCCESS = "success"
    let ERRORS = "errors"
    let CODE = "code"
    
    func get<T: Encodable>(with url: String, parameters: T?, headers: [String : String]?, success: @escaping ([String : Any]) -> Void, failure: @escaping (ApplicationError) -> Void) {
        AF.request(url, method: .get, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            self.dispatchConditionally(with: response, success: success, failure: failure)
        }
    }
    
    func post<T: Encodable>(with url: String, parameters: T?, headers: [String : String]?, success: @escaping ([String : Any]) -> Void, failure: @escaping (ApplicationError) -> Void) {
        AF.request(url, method: .post, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).responseJSON { response in
            self.dispatchConditionally(with: response, success: success, failure: failure)
        }
    }
    
    func put<T: Encodable>(with url: String, parameters: T?, headers: [String : String]?, success: @escaping ([String : Any]) -> Void, failure: @escaping (ApplicationError) -> Void) {
        AF.request(url, method: .put, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).responseJSON { response in
            self.dispatchConditionally(with: response, success: success, failure: failure)
        }
    }
    
    func delete<T: Encodable>(with url: String, parameters: T?, headers: [String : String]?, success: @escaping ([String : Any]) -> Void, failure: @escaping (ApplicationError) -> Void) {
        AF.request(url, method: .delete, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).responseJSON { response in
            self.dispatchConditionally(with: response, success: success, failure: failure)
        }
    }
    
    private func dispatchConditionally(with response: AFDataResponse<Any>, success: @escaping ([String: Any]) -> (), failure: @escaping (ApplicationError) -> ()) {
        if let value = response.value {
            let responseMap = value as? [String: Any]
            if let successBody = responseMap?[SUCCESS] as? [String: Any] {
                success(successBody)
            } else if let successBody = responseMap?[SUCCESS] as? String, successBody == "OK" {
                success(["message": "OK"])
            } else if let errorsBody = responseMap?[ERRORS] as? [[String: Any]], let error = errorsBody.first, let code = error[CODE] as? String, let error = ErrorCode(rawValue: code) {
               failure(ApplicationError(code: error))
            } else {
                failure(ApplicationError(code: .unknown))
            }
        } else if let error = response.error {
            if let errorCode = error.responseCode, let appErrorCode = ErrorCode(rawValue:  String(errorCode)) {
                failure(ApplicationError(code: appErrorCode))
            } else {
                failure(ApplicationError(code: .unknown))
            }
        }
    }
}

protocol ServiceManager {
    func get<T: Encodable>(with url: String, parameters: T?, headers: [String: String]?, success: @escaping ([String: Any]) -> Void, failure: @escaping (ApplicationError) -> Void)
    func post<T: Encodable>(with url: String, parameters: T?, headers: [String: String]?, success: @escaping ([String: Any]) -> Void, failure: @escaping (ApplicationError) -> Void)
    func put<T: Encodable>(with url: String, parameters: T?, headers: [String: String]?, success: @escaping ([String: Any]) -> Void, failure: @escaping (ApplicationError) -> Void)
    func delete<T: Encodable>(with url: String, parameters: T?, headers: [String: String]?, success: @escaping ([String: Any]) -> Void, failure: @escaping (ApplicationError) -> Void)
}
