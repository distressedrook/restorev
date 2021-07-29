//
//  Error.swift
//  Restorev
//
//  Created by Avismara HL on 29/07/21.
//
import Foundation

enum ErrorCode: String {
    // MARK: _ HTTP error codes
    case httpBadRequest = "400"
    case httpUnauthorized = "401"
    case httpForbidden = "403"
    case httpNotFound = "404"
    case httpMethodNotAllowed = "405"
    case httpInternalServerError = "500"
    case timedOut = "1001"
    case statusSuccessful = "200"
    
    // MARK: _ Unknown
    case unknown
}
