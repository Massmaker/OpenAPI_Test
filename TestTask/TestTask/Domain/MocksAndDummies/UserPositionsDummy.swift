//
//  UserPositionsDummy.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation
final class UserPositionsDummy: UserPositionsLoading {
    
    //returms 2 dummies after 2 seconds delay
    func getUserPositions() async throws -> [UserPosition] {
        
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000) //2 seconds delay
        
        return UserPosition.dummies
    }
    
    
}

extension UserPosition{
    static var dummies:[UserPosition] = [
        .init(id: 1, name: "Backend developer"),
        .init(id: 2, name: "Frontend developer"),
        .init(id: 3, name: "Dev Ops"),
        .init(id: 4, name: "UX UI designer"),
        .init(id: 5, name: "Marketing manager")
    ]
}
