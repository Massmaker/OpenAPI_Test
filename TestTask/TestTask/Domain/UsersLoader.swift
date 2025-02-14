//
//  UsersLoader.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

final class UsersLoader {

    private let decoder:JSONDecoder
    
    init() {
        let aDecoder = JSONDecoder()
        aDecoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder = aDecoder
    }
}

extension UsersLoader: Pageable  {
    typealias Value = User
    
    func loadPage(after currentPage: PageInfo, size: Int) async throws -> (items: [User], pageInfo: PageInfo) {
        
        guard let nextURLString = currentPage.nextCursor, let aURL = URL(string: nextURLString) else {
            throw URLError(.badURL)
        }
        
        do {
            let response = try await URLSession.shared.data(from: aURL)
            
            guard let httpResponse = response.1 as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200:
                do {
                    let data = response.0
                    
                    let decodedResponse = try decoder.decode(UsersPagedResponse.self, from: data)
                    
                    let lvPageInfo:PageInfo
                    
                    if let next = decodedResponse.links.nextUrl {
                        lvPageInfo = PageInfo(hasNext: true, nextCursor: next)
                    }
                    else {
                        lvPageInfo = PageInfo(hasNext: false, nextCursor: nil)
                    }
                    
                    return (items:decodedResponse.users, pageInfo:lvPageInfo)
                }
            case 404:
                throw APICallError.reasonableMessage("No more Users", HandledErrorStatusCode.notFound)
            case 422:
                throw APICallError.validationFailed(HandledErrorStatusCode.validationFailure)
            default:
                throw URLError(.badServerResponse)
            }
        }
        catch {
            throw error
        }
        
        
    }
    
}
