//
//  UserNameValidator.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation


/// - Requirements: Username should contain 2-60 characters
struct UserNameValidator: UserNameValidating {
    func validate(_ name: String) -> Bool {
        let charactersCount = name.count
        return charactersCount > 1 && charactersCount < 61
    }
}
