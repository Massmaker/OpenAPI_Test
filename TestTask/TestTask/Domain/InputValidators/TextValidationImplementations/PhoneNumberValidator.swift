//
//  PhoneNumberValidator.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//

import Foundation


fileprivate let kPhoneNumberPattern:String = "^[\\+]{0,1}380([0-9]{9})$" //taken from scheme : https://openapi_apidocs.abz.dev/frontend-test-assignment-v1#/users/post_users

struct PhoneNumberValidator: PhoneNumberValidating {
    typealias Input = String
    
    func validate(_ phone: String) -> Bool {
        return phone.matchesRegex(kPhoneNumberPattern)
    }
}
