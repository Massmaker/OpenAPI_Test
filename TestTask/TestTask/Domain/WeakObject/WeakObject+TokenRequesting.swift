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

extension WeakObject:UserRegistration where T:UserRegistration {
    func registerNew(user: UserRegistrationRequestInfo) async throws -> (userId: UserId, message: String) {
        guard let object else {
            throw WeakObjectError.noUnderlyingObject
        }
        return try await object.registerNew(user: user)
    }
    
    
}
