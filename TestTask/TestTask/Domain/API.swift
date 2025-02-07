//
//  API.swift
//  TestTask
//
//  Created by Ivan_Tests on 07.02.2025.
//

import Foundation

enum API {
    case getUsers(page:Int, size:Int)
}

extension API {
    var baseURL:String {
        "https://frontend-test-assignment-api.abz.agency/api/v1/"
    }
    
    var path:String {
        switch self {
        case .getUsers(let page, let size):
            "users?page=\(page)&count=\(size)"
        }
    }
    
    func requestURL() -> String {
        baseURL.appending(path)
    }
    
    var method:String {
        switch self {
        case .getUsers(let page, let size):
            "GET"
        }
    }
    
}
