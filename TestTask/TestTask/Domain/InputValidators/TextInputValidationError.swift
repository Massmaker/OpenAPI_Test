//
//  TextInputValidationError.swift
//  TestTask
//
//  Created by Ivan_Tests on 13.02.2025.
//

import Foundation

enum TextInputValidationError:Error{
    case invalidEmail(message:String)
    case invalidPhoneNumber(message:String)
    case invalidName(message:String)
}

extension TextInputValidationError {
    var errorMessage: String {
        switch self {
        case .invalidEmail(let message):
            message
        case .invalidPhoneNumber(let message):
            message
        case .invalidName(let message):
            message
        }
    }
}

extension TextInputValidationError:LocalizedError {
    var errorDescription: String? {
        NSLocalizedString(errorMessage, comment: "Message for predefined validation errors")
    }
}
