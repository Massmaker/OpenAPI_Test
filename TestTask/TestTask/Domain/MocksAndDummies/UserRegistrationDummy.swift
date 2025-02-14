//
//  UserRegistrationDummy.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

struct UserRegistrationDummy:UserRegistration {
    let succeeding:Bool
    
    func registerNew(user: UserRegistrationRequestInfo) async throws -> (userId: UserId, message: String) {
        if succeeding {
            return (userId:1, message:"Dummy User Id \"1\" is returned")
        }
        else {
            throw NotAnError(message: "Dummy Object used to register user")
        }
    }
}
