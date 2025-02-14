//
//  UserPosition.swift
//  TestTask
//
//  Created by Ivan_Tests on 11.02.2025.
//

import Foundation
struct UserPosition: Codable, Hashable {
    let id: Int
    let name: String
}

/// - Note: When decoding happens it using `'init(from decoder: any Decoder) throws'`  automatically sorts the `positions` array by id in the ascendong order

struct UserPositionsResponse :Decodable {
    let success:Bool
    let positions:[UserPosition]
    
    enum CodingKeys: CodingKey {
        case success
        case positions
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        var unsordetPositions = try container.decode([UserPosition].self, forKey: .positions)
        unsordetPositions.sort(by: {$0.id < $1.id})
        
        self.positions = unsordetPositions //sorted here
    }
}

struct UserPositionsFailureResponse:Decodable {
    let success:Bool
    private(set) var message:String?
}


extension UserPosition:SelectableItem {
    var title:String {
        self.name
    }
    //the `id` for Identifiable is already in the struct declaration
}
