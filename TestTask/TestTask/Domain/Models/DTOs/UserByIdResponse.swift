//
//  UserByIdResponse.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

struct UserByIdResponse:Decodable {
    let success:Bool
    let user:User
}

struct FailureResponse:Decodable {
    let success:Bool
    var message:String?
    var fails:[String:[String]]?
}
