//
//  UserPositionsDummy.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation
final class UserPositionsDummy: UserPositionsLoading {
    func getUserPositions() async throws -> [UserPosition] {
        return UserPosition.dummies
    }
    
    
}

extension UserPosition{
    static var dummies:[UserPosition] = [
        .init(id: 1, name: "Backend developer"),
        .init(id: 2, name: "Frontend developer")
    ]
}
