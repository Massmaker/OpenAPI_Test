//
//  String+Extensions.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation

extension String {
    fileprivate func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func matchesRegex(_ regex:String) -> Bool {
        matches(regex)
    }
}
