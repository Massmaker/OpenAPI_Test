//
//  UserByIdLoaderDummy.swift
//  TestTask
//
//  Created by Ivan_Tests on 17.02.2025.
//

import Foundation

struct UserByIdLoaderDummy:UserByIdLoading {
    func getUserBy(userId: UserId) async throws -> User {
        throw NotAnError(message: "Dummy loader used to obtain User byt UserId")
    }
}
