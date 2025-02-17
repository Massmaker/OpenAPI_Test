//
//  API.swift
//  TestTask
//
//  Created by Ivan_Tests on 07.02.2025.
//

import Foundation

/// The API uses Alamofire/Moya approach style (very simplified)
enum API {
    case getUsers(page:Int, size:Int)
    case getPositions
    case getToken
    case getUserBy(userId:UserId)
    case registerUser(info: any MultipartFormDataEncodable, token:String)
}

extension API {
    
    var baseURL:String {
        "https://frontend-test-assignment-api.abz.agency/api/v1/"
    }
    
    var path:String {
        switch self {
        case .getUsers:
            "users"
        case .getPositions:
            "positions"
        case .getToken:
            "token"
        case .registerUser:
            "users"
        case .getUserBy(userId: let userId):
            "users/\(userId)"
        }
    }
    
    var method:String {
        switch self {
        case .getUsers, .getPositions, .getToken, .getUserBy(userId:):
            "GET"
        case .registerUser:
            "POST"
        }
    }
    
    var pathParameters:[String:Any]? {
        switch self {
        case .getUsers(let page, let size):
            return ["page":page, "count":size]
        case .getPositions, .getToken, .getUserBy,  .registerUser:
            return nil
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

extension API {
    func requestPath() -> String {
        baseURL.appending(path)
    }
}
