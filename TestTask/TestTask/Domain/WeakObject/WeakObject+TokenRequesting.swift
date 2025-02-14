//
//  WeakObject+TokenRequesting.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

extension WeakObject:AccessTokenSupplier where T:AccessTokenSupplier {
    func getAccessToken() async throws -> AccessToken {
        guard let object else {
            throw WeakObjectError.noUnderlyingObject
        }
        
        return try await object.getAccessToken()
    }
}
