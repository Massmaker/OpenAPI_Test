//
//  UsersLoader.swift
//  TestTask
//
//  Created by Ivan_Tests on 14.02.2025.
//

import Foundation

final class UsersLoader {

    private let decoder:JSONDecoder
    private var lastResponseInfo:(response:UsersPagedResponse, requestURL:URL)?
    
    
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
        
        return try await loadUsersPageFrom(url: aURL)
    }
    
    
    func reloadLastPage(returnResults:Bool = false) async throws -> (items:[Value], pageInfo:PageInfo) {
        guard let lastResponseInfo else {
            throw APICallError.reasonableMessage("No valid page info to reload", HandledErrorStatusCode.notFound)
        }
        
        let page = lastResponseInfo.response.page
        let count = lastResponseInfo.response.count
        
        let lastRequestedPageURL = lastResponseInfo.requestURL
        
        if returnResults {
            return  try await loadUsersPageFrom(url: lastRequestedPageURL)
        }
        else {
            do {
                let response = try await loadUsersPageFrom(url: lastRequestedPageURL)
                
                return (items:[], pageInfo:response.pageInfo)
            }
            catch {
                throw error
            }
 
        }
    }
    
    private func loadUsersPageFrom(url:URL) async throws -> (items:[Value], pageInfo:PageInfo) {
        do {
            let response = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response.1 as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200:
                do {
                    let data = response.0
                    
                    let decodedResponse = try decoder.decode(UsersPagedResponse.self, from: data)
                    
                    self.lastResponseInfo = (response:decodedResponse, requestURL:url)
                    
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

