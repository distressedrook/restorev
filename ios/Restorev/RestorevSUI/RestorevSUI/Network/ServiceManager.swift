//
//  ServiceManager.swift
//  RestorevSUI
//
//  Created by Avismara Hugoppalu on 02/01/23.
//

import Alamofire
import Foundation

struct ServiceManagerImp: ServiceManager {
    let SUCCESS = "success"
    let ERRORS = "errors"
    let CODE = "code"

    @discardableResult
    func get<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any] {
        if !InternetConnectionManager.isConnectedToNetwork() {
            throw ApplicationError(code: ErrorCode.noInternet)
        }
        let dataTask = AF.request(url, method: .get, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).serializingData()
        let response = await dataTask.response
        return try self.dispatchConditionally(with: response)

    }

    @discardableResult
    func post<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any] {
        if !InternetConnectionManager.isConnectedToNetwork() {
            throw ApplicationError(code: ErrorCode.noInternet)
        }
        let dataTask = AF.request(url, method: .post, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).serializingData()
        let response = await dataTask.response
        return try self.dispatchConditionally(with: response)

    }

    @discardableResult
    func put<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any] {
        if !InternetConnectionManager.isConnectedToNetwork() {
            throw ApplicationError(code: ErrorCode.noInternet)
        }
        let dataTask = AF.request(url, method: .put, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).serializingData()
        let response = await dataTask.response
        return try self.dispatchConditionally(with: response)

    }

    @discardableResult
    func delete<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any] {
        if !InternetConnectionManager.isConnectedToNetwork() {
            throw ApplicationError(code: ErrorCode.noInternet)
        }
        let dataTask = AF.request(url, method: .delete, parameters: parameters, headers: HTTPHeaders(headers ?? [:])).serializingData()
        let response = await dataTask.response
        return try self.dispatchConditionally(with: response)

    }

    private func dispatchConditionally(with response: DataResponse<Data, AFError>) throws -> [String: Any]  {
        if let value = response.value {
            let responseMap = try JSONSerialization.jsonObject(with: value) as? [String: Any]
            if let successBody = responseMap?[SUCCESS] as? [String: Any] {
                return successBody
            } else if let successBody = responseMap?[SUCCESS] as? String, successBody == "OK" {
                return ["message": "OK"]
            } else if let errorsBody = responseMap?[ERRORS] as? [[String: Any]], let error = errorsBody.first, let code = error[CODE] as? String, let error = ErrorCode(rawValue: code) {
                if code == "403" {
                    NotificationCenter.default.post(Notification(name: Notifications.forbidden.name))
                }
                throw ApplicationError(code: error)
            } else {
                throw ApplicationError( code: .unknown)
            }
        } else if let error = response.error {
            if error.responseCode == 403 {
                NotificationCenter.default.post(Notification(name: Notifications.forbidden.name))
            }
            if let errorCode = error.responseCode, let appErrorCode = ErrorCode(rawValue:  String(errorCode)) {
                throw ApplicationError(code: appErrorCode)
            } else {
                throw ApplicationError(code: .unknown)
            }
        }
        throw ApplicationError(code: .unknown)
    }
}

protocol ServiceManager {
    @discardableResult
    func get<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any]

    @discardableResult
    func post<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any]

    @discardableResult
    func put<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any]

    @discardableResult
    func delete<T: Encodable>(with url: String, parameters: T? , headers: [String: String]?) async throws -> [String: Any]

}
