//
//  ServiceManager.swift
//  HomeGenius
//
//  Created by Avismara HL on 22/11/18.
//  Copyright © 2018 Infrrd Technologies Private Limited. All rights reserved.
//

import Alamofire
import Foundation

class ServiceManagerImp: ServiceManager {
    
    // MARK: - Private parse constants
    private let STATUS = "status"
    private let SUCCESS = "SUCCESS"
    private let failure = "FAILURE"
    private let RESULT = "result"
    private let CODE = "code"
    private let MESSAGE = "message"
    private let ERRORS = "errors"
    private let AUTHORIZATION = "Authorization"

    // MARK: - Public Methods
    func get(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        performBlockWithFreshToken(headers: headers, failure: failure) {
            let header = self.replaceTokenIfNeeded(headers: headers)
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding(boolEncoding: .literal), headers: header).validate().responseJSON { response in
                self.dispatchConditionally(with: response, success: success, failure: failure)
            }
        }
    }
}
 
extension ServiceManagerImp {
    
    func post(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        performBlockWithFreshToken(headers: headers, failure: failure) {
            let header = self.replaceTokenIfNeeded(headers: headers)
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in
                self.dispatchConditionally(with: response, success: success, failure: failure)
            }
        }
    }
    
    func post(with url: String, timeOut: TimeInterval, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void) {
            guard let url = URL(string: url) else {
                return
            }
            performBlockWithFreshToken(headers: headers, failure: failure) {
                let header = self.replaceTokenIfNeeded(headers: headers)
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = timeOut
                configuration.timeoutIntervalForResource = timeOut
                self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
                self.alamoFireManager?.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in
                    self.dispatchConditionally(with: response, success: success, failure: failure)
                }
            }
        }
    
    func urlEncodedPost(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        performBlockWithFreshToken(headers: headers, failure: failure) {
            let header = self.replaceTokenIfNeeded(headers: headers)
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: header).validate().responseJSON { response in
                self.dispatchConditionally(with: response, success: success, failure: failure)
            }
        }
    }
}
 
extension ServiceManagerImp {
    func put(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        performBlockWithFreshToken(headers: headers, failure: failure) {
            let header = self.replaceTokenIfNeeded(headers: headers)
            Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in
                self.dispatchConditionally(with: response, success: success, failure: failure)
            }
        }

    }
    
    func delete(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        performBlockWithFreshToken(headers: headers, failure: failure) {
            let header = self.replaceTokenIfNeeded(headers: headers)
            Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate().responseJSON { response in
                self.dispatchConditionally(with: response, success: success, failure: failure)
            }
        }
    }
}

extension ServiceManagerImp {
    // MARK: - Private Methods
    private func dispatchConditionally(with response: DataResponse<Any>, success: @escaping ([String: Any]) -> Void, failure: @escaping (GatewayError) -> Void) {
        switch response.result {
        case .success:
            let responseMap = response.result.value as? [String: Any] ?? [String: Any]()
            guard (responseMap[STATUS] as? String) != nil else {
                return
            }
            if let gatewayError = parseGatewayError(with: responseMap) {
                failure(gatewayError)
                return
            }
            let successResult = self.parseGatewaySuccess(with: responseMap)
            success(successResult)
            
        case .failure:
            Log.d("FAILURE: \(response.result.error?.localizedDescription as Any)")
            if let statusCode = response.response?.statusCode {
                let gatewayError = self.gatewayError(for: statusCode)
                failure(gatewayError)
            } else if let error = response.result.error as? GatewayError {
                failure(error)
            } else if let errorString = response.result.error?.localizedDescription, errorString.lowercased().contains("timed out") {
                failure(self.gatewayError(for: 1001))
            } else {
                failure(self.gatewayError(for: -1))
            }
        }
    }
    
    private func parseGatewayError(with responseMap: [String: Any]) -> GatewayError? {
        var gatewayError = GatewayError()
        let result = responseMap[RESULT] as? [String: Any]
        guard let errors = result?[ERRORS] as? [[String: Any]] else {
            return nil
        }
        for error in errors {
            if let code = error[CODE] as? String, let errorCode = ErrorCode(rawValue: code) {
                if code == ErrorCode.DSP_NYL_4001.rawValue {
                    presentNylasAuth = true
                }
                var errorObject = HGError(code: errorCode)
                errorObject.errorDescriptionFromAPI = error[MESSAGE] as? String
                gatewayError.errors.append(errorObject)
            } else {
                var errorObject = HGError(code: ErrorCode.unknownError)
                errorObject.errorDescriptionFromAPI = error[MESSAGE] as? String
                gatewayError.errors.append(errorObject)
            }
        }
        return gatewayError
    }
    
    private func parseGatewaySuccess(with responseMap: [String: Any]) -> [String: Any] {
        if let result = responseMap[RESULT] as? [String: Any] {
            return result
        } else if let result = responseMap[RESULT] {
            return [RESULT: result]
        } else {
            return [String: Any]()
        }
    }
    
    private func gatewayError(for code: Int) -> GatewayError {
        var gatewayError = GatewayError()
        let errorCodeEnum = ErrorCode(rawValue: errorCode) ?? .unknown
        gatewayError.errors.append(HGError(code: errorCodeEnum))
        return gatewayError
    }
    
    private func performBlockWithFreshToken(headers: [String: String]?, failure: @escaping (GatewayError) -> Void, block: @escaping ServiceBlock) {
        
        DispatchQueue.main.async {
            if !NetworkConnectivity.connectedToInternet {
                Log.d("Not connected to the internet")
                var gatewayError = GatewayError()
                gatewayError.errors.append(HGError(code: ErrorCode.noInternetConnection))
                failure(gatewayError)
                return
            }
            guard headers?[self.AUTHORIZATION] != nil else {
                block()
                return
            }
            NotificationCenter.default.post(name: .refreshAndMakeServiceCall, object: self, userInfo: [AuthorizedServiceManager.blockUserInfoKey: block])
        }
    }
    
    private func replaceTokenIfNeeded(headers: [String: String]?) -> [String: String]? {
        guard var header = headers, header[AUTHORIZATION] != nil else {
            return headers
        }
        header[AUTHORIZATION] = bearerString()
        return header
    }
}

protocol ServiceManager {
    func get(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void)
    
    func post(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void)
    func post(with url: String, timeOut: TimeInterval, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void)
    
    
    func put(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void)
    
    func delete(with url: String, parameters: [String: Any]?, headers: [String: String]?, success: @escaping ([String: Any]?) -> Void, failure: @escaping (GatewayError) -> Void)
    
    
}
