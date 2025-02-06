//
//  User.swift
//  TestTask
//
//  Created by Ivan Yavorin on 06.02.2025.
//

import Foundation

typealias UserId = String
typealias UserPositionId = String
typealias UserPhotoLink = String

/// - Important: use keyDecodingStrategy `convertFromSnakeCase` for reteiving data and keyEncodingStartegy `convertToSnakeCase` for posting data

struct User:Decodable {
    let name: String
    let id: UserId
    let email:String
    let phone:String
    let position:String
    let positionId:UserPositionId
    var photo:UserPhotoLink?
    var registrationTimeStamp:TimeInterval
}


extension User {
    static var dummies:[User] {
        [User(name: "Ivan Yavorin", id: "12333", email: "some.email@service.com", phone: "+38097444333222", position: "iOS Developer", positionId: "11223344", photo: nil, registrationTimeStamp: 123999445),
         User(name: "John Doe", id: "12334", email: "another.email@service.com", phone: "+38097444333233", position: "Dummy user", positionId: "1001", photo: nil, registrationTimeStamp: 123999433)
         ]
    }
}

//MARK: -
import UIKit
struct UserInfo:Hashable, Identifiable {

    let id:UserId
    let name:String
    let positionTitle:String
    let emailString:String
    let phoneNumberString:String
    
    private(set) var image:UIImage?

    mutating func setImage(_ uiImage:UIImage) {
        self.image = uiImage
    }
}
extension UserInfo {
    static func fromUser(_ user:User) -> UserInfo {
        if let link = user.photo {
            UserInfo(id: "TestUserId_1", name: user.name, positionTitle: user.position, emailString: user.email, phoneNumberString: user.email, image: ImageCache.imageForPhotoLink(link))
        }
        else {
            UserInfo(id: "TestUserId_1", name: user.name, positionTitle: user.position, emailString: user.email, phoneNumberString: user.email, image: nil)
        }
    }
}
