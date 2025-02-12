//
//  AlwaysSucceedingStringValidator.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation

struct AlwaysSucceedingStringValidator:StringInputValidation {
    func validate(_ input: String) -> Bool {
        return true
    }
}
