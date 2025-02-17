//
//  UsersPageResponse.swift
//  TestTask
//
//  Created by Ivan_Tests on 07.02.2025.
//

import Foundation

struct UsersPagedResponse: Decodable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let links: Links
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
            case success
            case totalPages
            case totalUsers
            case count
            case page
            case links
            case users
        }
}

struct Links:Decodable {
    let nextUrl: String?
    let prevUrl: String?
}
