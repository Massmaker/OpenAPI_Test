//
//  APICallErrors.swift
//  TestTask
//
//  Created by Ivan_Tests on 07.02.2025.
//

import Foundation

enum APICallError:Error {
    case validationFailed(HandledErrorStatusCode?)
    case reasonableMessage(String, HandledErrorStatusCode?)
    case detailedError(FailureResponse, HandledErrorStatusCode?)
}

enum HandledErrorStatusCode:Int {
    case expiredToken = 401
    case notFound = 404
    case duplicateData = 409
    case validationFailure = 422
}
