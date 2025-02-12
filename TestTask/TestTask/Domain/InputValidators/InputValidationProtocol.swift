//
//  InputValidationProtocol.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation

/// a generic protocol
protocol InputValidation {
    associatedtype Input
    func validate(_ input:Input) -> Bool
}


//MARK: - validations per string input type

/// specialized protocol for input strings validation
protocol StringInputValidation: InputValidation where Input == String {}

protocol UserNameValidating: StringInputValidation {}
protocol EmailStringValidating: StringInputValidation {}
protocol PhoneNumberValidating: StringInputValidation {}


//MARK: - photo jpeg data validation
/// - Important: validation should take image data previously converted to JPEG format
protocol ProfileImageValidating: InputValidation where Input == Data {}
