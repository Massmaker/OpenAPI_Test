//
//  User.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

typealias UserId = Int
typealias UserPositionId = Int
typealias UserPhotoLink = String

/// - Important: use keyDecodingStrategy `convertFromSnakeCase` for reteiving data and keyEncodingStartegy `convertToSnakeCase` for posting data

struct User:Decodable, Hashable, Identifiable {
    let name: String
    let id: UserId
    let email:String
    let phone:String
    let position:String
    let positionId:UserPositionId
    var photo:UserPhotoLink?
    var registrationTimestamp:TimeInterval
}


extension User {
    static var dummies:[User] {
        [User(name: "Ivan Yavorin", id: 12333, email: "some.email@service.com", phone: "+38097444333222", position: "iOS Developer", positionId: 11223344, photo: nil, registrationTimestamp: 123999445),
         User(name: "John Doe", id: 12334, email: "another.email@service.com", phone: "+38097444333233", position: "Dummy user", positionId: 1001, photo: nil, registrationTimestamp: 123999433),
         User(name: "Rochelle Bartoletti Melba Satterfield", id: 334455, email: "georgette_powlowski24@hotmail.com", phone: "+38 (098) 278 76 24", position: "QA", positionId: 203,  photo: nil, registrationTimestamp: 123999434)
         ]
    }
}


extension User {
    func imageURL() -> URL? {
        guard let string = photo,
              let url = URL(string: string) else {
            return nil
        }
        
        return url
    }
}

