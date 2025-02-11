//
//  API.swift
//  TestTask
//
//  Created by Ivan_Tests on 07.02.2025.
//

import Foundation

enum API {
    case getUsers(page:Int, size:Int)
    case getPositions
    case getToken
    case registerUser(info:UserRegistrationInfo, token:String)
}

extension API {
    var baseURL:String {
        "https://frontend-test-assignment-api.abz.agency/api/v1/"
    }
    
    var path:String {
        switch self {
        case .getUsers(let page, let size):
            "users?page=\(page)&count=\(size)"
        case .getPositions:
            "positions"
        case .getToken:
            "token"
        case .registerUser:
            "users"
        }
    }
    
    func requestURL() -> String {
        baseURL.appending(path)
    }
    
    var method:String {
        switch self {
        case .getUsers, .getPositions, .getToken:
            "GET"
        case .registerUser:
            "POST"
        }
    }
    
    var authorizationHeader:String? {
        switch self {
       
        case .registerUser(_, let token):
            return "Token \(token)"
        default:
            return nil
        }
    }
    
}
