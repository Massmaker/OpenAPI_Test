//
//  FlowErrors.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

struct NotAnError:Error {
    var message:String?
}

extension NotAnError:LocalizedError {
    var errorDescription: String? {
        message
    }
}
